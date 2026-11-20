# myerlangapp

A minimal, single-app Erlang/OTP release used to exercise and test [rebar3_jellyfish_plugin](https://github.com/deployex/rebar3_jellyfish_plugin) across releases.

Same functionality as [medusa](https://github.com/deployex/medusa), but as one plain OTP application instead of an umbrella - a counterpart to test the plugin's single-app path (and, since the release name here is also the one application's name, `rebar3_appup_plugin`'s single-app assumption too, if that's ever wanted).

## What's here

A `gen_server` holding a single integer counter in its state (`myerlangapp_server`), and a dependency-free HTTP listener (plain `gen_tcp`, no framework) serving a page at `/` showing the counter, with `/bump` to increment it.

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
