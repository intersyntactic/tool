# Changelog

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
