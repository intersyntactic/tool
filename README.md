# is_tool

What an intersyntactic tool does when it is called. A tool is its
`is_tools_api` definition: what the model sees, what a call takes and what
it returns. It does not carry what it does: that is passed to `handledBy`,
so one definition can be handled differently in different programs.

```dart
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
```

- `spec.handledBy(does)`: a `ToolHandler<I, O>`. `does` is given a call's
  input and returns the actions it takes and the answer they lead to, an
  `is_airlock_api` `Result<O>`; it touches nothing. It must take the
  definition's `I` and end in its `O`, or it does not compile.
- `handler.reply(json, crux)`: reads the input with the definition, runs
  each action through the crux, where the airlock decides it and writes it to
  the logbook, and renders `Done` with the definition's `Output`. An input
  the definition refuses, and a `Failed`, become a `ToolResponse` with
  `isError`.
- `execResultOutput`: an `Output` for a tool whose answer is an
  `is_effects` `ExecResult`: how it ended (`exit 0`, or `killed: why`) and
  its stdout and stderr, both always shown. Exit 0 is not a measurement.

The library imports `is_airlock_api`, `is_effects` and `is_tools_api`, and no
runner, client or effect; a test reads every directive's URI from Dart's
parse tree and holds it to that.
