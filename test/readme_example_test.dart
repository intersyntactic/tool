import 'dart:io';

import 'package:test/test.dart';

/// The lines strictly between [start] and [end], from the first [start].
List<String> _between(
  List<String> lines,
  bool Function(String) start,
  bool Function(String) end,
) {
  final from = lines.indexWhere(start);
  if (from == -1) return const [];
  final to = lines.indexWhere(end, from + 1);
  return lines.sublist(from + 1, to == -1 ? lines.length : to);
}

void main() {
  test("the README's example is the one analysis compiles", () {
    final readme = _between(
      File('README.md').readAsLinesSync(),
      (line) => line == '```dart',
      (line) => line == '```',
    );
    // The example's body is indented one level inside its function.
    final example = [
      for (final line in _between(
        File('example/is_tool_example.dart').readAsLinesSync(),
        (line) => line.trim() == '// readme-example-start',
        (line) => line.trim() == '// readme-example-end',
      ))
        line.startsWith('  ') ? line.substring(2) : line,
    ];
    expect(readme, isNotEmpty);
    expect(
      readme,
      example,
      reason:
          'change the README example and example/is_tool_example.dart '
          'together',
    );
  });
}
