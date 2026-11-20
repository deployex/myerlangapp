# myerlangapp

A minimal, single-app Erlang/OTP release used to exercise and test [rebar3_jellyfish_plugin](https://github.com/deployex/rebar3_jellyfish_plugin) across releases.

Same functionality as [medusa](https://github.com/deployex/medusa), but as one plain OTP application instead of an umbrella - a counterpart to test the plugin's single-app path (and, since the release name here is also the one application's name, `rebar3_appup_plugin`'s single-app assumption too, if that's ever wanted).

## What's here

A `gen_server` holding a single integer counter in its state (`myerlangapp_server`), plus (as of 0.2.0) a sibling `gen_server` tracking how many times it's been bumped, and a dependency-free HTTP listener (plain `gen_tcp`, no framework) serving a page at `/` showing both counters, with `/bump` to increment them.

## Running

```bash
rebar3 release
_build/default/rel/myerlangapp/bin/myerlangapp console
```

Then open <http://127.0.0.1:8080/>.

## Plugin under test

`rebar3_jellyfish_plugin` is pulled from Hex in `rebar.config`. A `relup-guard-erlang` CI check (`.github/workflows/relup-guard.yml`) builds the base and head of every PR and runs a real hot upgrade between them.

## Versions

 * `0.1.0` - initial release.
 * `0.2.0` - adds `myerlangapp_history_server`, a new supervised child tracking bump counts, and wires `myerlangapp_server` to notify it on every bump. This exercises `add_module` and a supervisor-spec update rather than a `code_change`-based state migration: `myerlangapp_server` doesn't export `code_change/3` in 0.1.0, so an upgrade from that version would never invoke one anyway, no matter what 0.2.0 adds - the instruction an upgrade uses is chosen from the currently-deployed version's own exports.
