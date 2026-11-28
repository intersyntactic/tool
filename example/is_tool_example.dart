import 'package:is_airlock_api/is_airlock_api.dart';
import 'package:is_file_request_vocabulary/is_file_request_vocabulary.dart';
import 'package:is_program_request_vocabulary/is_program_request_vocabulary.dart';
import 'package:is_relative_path_vocabulary/is_relative_path_vocabulary.dart';
import 'package:is_tool/is_tool.dart';
import 'package:is_tool_definition_vocabulary/is_tool_definition_vocabulary.dart';

/// The README's example, as a function so analysis compiles it.
///
/// The body between the markers is the README's ```dart block, line for
/// line; test/readme_example_test.dart holds the two together.
Future<ToolResponse> writeAndFormatReply(
  JsonObject input,
  ProposesActions proposer,
) async {
  // readme-example-start
  final dart = Executable.parse('dart')!;

  final writeAndFormat =
      ToolSpec<FileText, ExecResult>(
        name: ToolName.of('write_and_format'),
        description: 'Writes a Dart file, then formats it.',
        input: Input.fields2(
          Field('path', Schema.string()),
          Field('text', Schema.string()),
          (String path, String text) => FileText(RelativePath(path), text),
        ),
        output: execResultOutput,
      ).handledBy(
        (file) => Program.write.runOrFail(
          file,
          then: (wrote) =>
              dart.runOrFail(Args(['format', file.path.value]), then: Done.new),
        ),
      );

  final response = await writeAndFormat.reply(input, proposer);
  // response.forModel, response.isError: the call's tool result.
  // readme-example-end
  return response;
}
