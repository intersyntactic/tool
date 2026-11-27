# Changelog

## 0.12.0

- Depends on `is_airlock_api` `^0.22.0`. No code change.

## 0.11.0

- Depends on `is_airlock_api` `^0.21.0` and `is_effects` `^0.17.0`.
- `ToolHandler.reply` takes a `ProposesActions`, `Crux`'s new name: an
  interface with one method, so a test can pass a fake.

## 0.10.0

- Depends on `is_tools_api` `^0.5.0`. No code change in `lib`.
- The README example names its tool with `ToolName.of('write_and_format')`,
  since `ToolSpec.name` is now a `ToolName`.

## 0.9.0

- Depends on `is_airlock_api` `^0.18.0` and `is_effects` `^0.15.0`. No code
  change in `lib`.
- The README example uses `runOrFail`, `runOrRefusal`'s new name. A program
  that stopped partway now reaches the model as an error starting
  `stopped partway:`, unlike one where nothing ran.

## 0.8.0

- Depends on `is_tools_api` `^0.4.0`. No code change.

## 0.7.0

- Depends on `is_tools_api` `^0.3.0`. No code change.
- The README example is compiled: it lives in `example/is_tool_example.dart`,
  and a test holds the README's copy to it.

## 0.6.0

- Depends on `is_airlock_api` `^0.17.0` and `is_effects` `^0.14.1`. No
  code change.

## 0.5.0

- Depends on `is_airlock_api` `^0.16.0` and `is_effects` `^0.13.0`. No
  code change.
- Docs say "the logbook" for what the airlock writes, and no longer say
  "host". The README example builds again: `RelativePath` in place of
  `PathInRepo`.

## 0.4.0

- Depends on `is_airlock_api` `^0.14.0`. No code change.

## 0.3.0

- Depends on `is_airlock_api` `^0.13.1` and `is_effects` `^0.12.0`. No
  code change.

## 0.2.0

Breaking. Brought up to `is_airlock_api` 0.9.0.

- `ToolHandler.reply(json, crux)` takes a `Crux` in place of an `Apex`,
  and runs each `Action` (was `Run`) through it.
- Docs say "actions" and "run through", not "runs" and "followed".
- Depends on `is_airlock_api` `>=0.9.0 <0.11.0` and `is_effects`
  `>=0.7.0 <0.9.0`, built and tested at both ends of each range.

## 0.1.0

- First release: `ToolHandler`, `handledBy`, `ToolResponse` and
  `execResultOutput`, an `is_tools_api` definition handled by `is_airlock_api`
  runs, moved out of `is_airlock_api` 0.1.0 (where `ToolHandler` was `Tool`).
