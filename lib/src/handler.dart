import 'package:is_airlock_api/is_airlock_api.dart';
import 'package:is_effects/is_effects.dart';
import 'package:is_tools_api/is_tools_api.dart';

/// A definition, and how a call to it is carried out.
///
/// A tool is its definition, and does not carry what it does: that is
/// passed to [HandledBy.handledBy], so one definition can be handled
/// differently in different programs.
///
/// Made only by [HandledBy.handledBy], so what it does takes the
/// definition's [I] and ends in its [O]: a handler that gives a `String` for
/// a `ToolSpec<Args, ExecResult>` does not compile.
final class ToolHandler<I, O> {
  const ToolHandler._(this.spec, this._does);

  final ToolSpec<I, O> spec;
  final Result<O> Function(I input) _does;

  /// A call taking [input], run through at [crux] to what the model is told.
  ///
  /// Here, where [I] and [O] are known, so whoever holds a handler of
  /// unknown types never handles its input or output. An input the
  /// definition does not accept is an error naming the field; nothing is run
  /// for it.
  Future<ToolResponse> reply(JsonObject input, Crux crux) async {
    final I read;
    try {
      read = spec.input.read(input);
    } on JsonFieldException catch (e) {
      return ToolResponse._(e.message, isError: true);
    }
    var result = _does(read);
    while (true) {
      switch (result) {
        case Done(:final value):
          return ToolResponse._(spec.output.forModel(value), isError: false);
        case Failed(:final why):
          return ToolResponse._(why, isError: true);
        case Action():
          result = await result.next(crux);
      }
    }
  }
}

/// What the model is told of a call: [forModel], as its tool result, marked
/// [isError] when the call failed.
final class ToolResponse {
  const ToolResponse._(this.forModel, {required this.isError});

  final String forModel;
  final bool isError;
}

extension HandledBy<I, O> on ToolSpec<I, O> {
  /// This definition, handled by [does]: given a call's input, the actions it
  /// takes and the answer they lead to.
  ToolHandler<I, O> handledBy(Result<O> Function(I input) does) =>
      ToolHandler._(this, does);
}

/// An [ExecResult] as the model is told it, for a definition whose answer is
/// one.
///
/// stderr is INCLUDED even on success, and how it ended is always stated. A
/// command that printed a warning and succeeded, and one that printed the
/// same text and failed, are different events; a transcript that shows only
/// stdout makes them identical. Exit 0 is not a measurement.
const execResultOutput = Output<ExecResult>(_execForModel);

String _execForModel(ExecResult result) {
  final b = StringBuffer(switch (result) {
    Exited(:final exitCode) => 'exit $exitCode',
    Killed(:final why) => 'killed: $why; no exit code',
  });
  final anyOut = result.stdout.trim().isNotEmpty;
  final anyErr = result.stderr.trim().isNotEmpty;
  if (anyOut) b.write('\n--- stdout ---\n${result.stdout.trimRight()}');
  if (anyErr) b.write('\n--- stderr ---\n${result.stderr.trimRight()}');
  if (!anyOut && !anyErr) b.write(' (no output)');
  return b.toString();
}
