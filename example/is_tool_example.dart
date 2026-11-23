import 'package:is_airlock_api/is_airlock_api.dart';
import 'package:is_effects/is_effects.dart';
import 'package:is_tool/is_tool.dart';
import 'package:is_tools_api/is_tools_api.dart';

/// The README's example, as a function so analysis compiles it.
///
/// The body between the markers is the README's ```dart block, line for
/// line; test/readme_example_test.dart holds the two together.
Future<ToolResponse> writeAndFormatReply(JsonObject input, Crux crux) async {
  // readme-example-start
  final dart = Executable.parse('dart')!;

  final writeAndFormat =
      ToolSpec<FileText, ExecResult>(
        name: 'write_and_format',
        description: 'Writes a Dart file, then formats it.',
        input: Input.fields2(
          Field('path', Schema.string()),
          Field('text', Schema.string()),
          (String path, String text) => FileText(RelativePath(path), text),
        ),
        output: execResultOutput,
      ).handledBy(
        (file) => Program.write.runOrRefusal(
          file,
          then: (wrote) => dart.runOrRefusal(
            Args(['format', file.path.value]),
            then: Done.new,
          ),
        ),
      );

  final response = await writeAndFormat.reply(input, crux);
  // response.forModel, response.isError: the call's tool result.
  // readme-example-end
  return response;
}
