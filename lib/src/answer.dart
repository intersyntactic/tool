import 'package:is_airlock_api/is_airlock_api.dart';
import 'package:is_tools_api/is_tools_api.dart';

/// How a tool's calls are answered, here: its definition, and what it does
/// when called.
///
/// A tool is its definition, and does not carry what it does: each host
/// answers the definitions it offers, so one tool can be answered one way on
/// a laptop and another on a phone.
///
/// Made only by [AnsweredBy.answeredBy], so what it does takes the
/// definition's [I] and ends in its [O]: an answer that gives a `String` for
/// a `ToolSpec<Args, ExecResult>` does not compile.
final class Answer<I, O> {
  const Answer._(this.spec, this._does);

  final ToolSpec<I, O> spec;
  final Result<O> Function(I input) _does;

  /// A call taking [input], followed on [journeyPath] to what the model is
  /// told.
  ///
  /// Here, where [I] and [O] are known, so whoever holds an answer of
  /// unknown types never handles its input or output. An input the
  /// definition does not accept is an error naming the field; nothing is run
  /// for it.
  Future<Reply> reply(
    JsonObject input,
    JourneyPath<Object?> journeyPath,
  ) async {
    final I read;
    try {
      read = spec.input.read(input);
    } on JsonFieldException catch (e) {
      return Reply._(e.message, isError: true);
    }
    var result = _does(read);
    while (true) {
      switch (result) {
        case Done(:final value):
          return Reply._(spec.output.forModel(value), isError: false);
        case Failed(:final why):
          return Reply._(why, isError: true);
        case Run():
          result = await result.next(journeyPath);
      }
    }
  }
}

/// What the model is told of a call: [forModel], as its tool result, marked
/// [isError] when the call failed.
final class Reply {
  const Reply._(this.forModel, {required this.isError});

  final String forModel;
  final bool isError;
}

extension AnsweredBy<I, O> on ToolSpec<I, O> {
  /// This definition, answered by [does]: given a call's input, the runs it
  /// takes and the answer they lead to.
  Answer<I, O> answeredBy(Result<O> Function(I input) does) =>
      Answer._(this, does);
}

/// [ExecResult.forModel], as a definition renders an [ExecResult] answer.
const execResultOutput = Output<ExecResult>(_execForModel);

String _execForModel(ExecResult result) => result.forModel;
