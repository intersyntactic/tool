# is_tool

What an intersyntactic tool does when it is called. A tool is its
`is_tools_api` definition: what the model sees, what a call takes and what
it returns. It does not carry what it does: each host answers the
definitions it offers, so one tool can be answered one way on a laptop and
another on a phone.

```dart
final dart = Executable.parse('dart')!;

final writeAndFormat = ToolSpec<FileText, ExecResult>(
  name: 'write_and_format',
  description: 'Writes a Dart file, then formats it.',
  input: Input.fields2(
    Field('path', Schema.string()),
    Field('text', Schema.string()),
    (String path, String text) => FileText(PathInRepo.parse(path)!, text),
  ),
  output: execResultOutput,
).answeredBy(
  (file) => Program.write.runOrRefusal(
    file,
    then: (wrote) =>
        dart.runOrRefusal(Args(['format', file.path.value]), then: Done.new),
  ),
);

final reply = await writeAndFormat.reply(input, journeyPath);
// reply.forModel, reply.isError: the call's tool result.
```

- `spec.answeredBy(does)`: an `Answer<I, O>`. `does` is given a call's input
  and returns the runs it takes and the answer they lead to, an
  `is_airlock_api` `Result<O>`; it touches nothing. It must take the
  definition's `I` and end in its `O`, or it does not compile.
- `answer.reply(json, journeyPath)`: reads the input with the definition,
  follows each run on the journey path, where the airlock decides and
  records it, and renders `Done` with the definition's `Output`. An input
  the definition refuses, and a `Failed`, are replies with `isError`.
- `execResultOutput`: an `Output` for a tool whose answer is an
  `is_effects` `ExecResult`: how it ended (`exit 0`, or `killed: why`) and
  its stdout and stderr, both always shown. Exit 0 is not a measurement.

The library imports `is_airlock_api`, `is_effects` and `is_tools_api`, and no
runner, client or effect; a test reads every directive's URI from Dart's
parse tree and holds it to that.
