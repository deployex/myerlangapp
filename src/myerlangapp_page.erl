%%%-------------------------------------------------------------------
%% @doc HTML for myerlangapp's single page.
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_page).

-export([render/2, not_found/0]).

render(Count, Bumps) ->
    iolist_to_binary([
        "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\">"
        "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
        "<title>myerlangapp</title><style>", css(), "</style></head><body>",
        "<main class=\"card\">",
        "<h1>myerlangapp</h1>",
        "<p class=\"tagline\">single-app rebar3_jellyfish_plugin test harness</p>",
        "<p class=\"count\">", integer_to_list(Count), "</p>",
        "<p class=\"bumps\">", integer_to_list(Bumps), " bump(s)</p>",
        "<a class=\"button\" href=\"/bump\">Bump</a>",
        "</main></body></html>"
    ]).

not_found() ->
    <<"<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\">"
      "<title>Not Found</title></head>"
      "<body><h1>404</h1><p>Not found.</p></body></html>">>.

css() ->
    "body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;"
    "background:linear-gradient(135deg,#0f2027,#203a43,#2c5364);"
    "font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;color:#e8f6f3}"
    ".card{background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.12);"
    "border-radius:16px;padding:48px 64px;text-align:center;"
    "box-shadow:0 20px 60px rgba(0,0,0,.35)}"
    "h1{margin:0 0 4px;font-size:2.5rem;letter-spacing:.02em;"
    "background:linear-gradient(90deg,#6ee7b7,#60a5fa);-webkit-background-clip:text;"
    "background-clip:text;color:transparent}"
    ".tagline{margin:0 0 32px;color:#9fd8cf;font-size:.95rem}"
    ".count{font-size:4rem;font-weight:700;margin:0 0 4px;color:#fff}"
    ".bumps{font-size:.85rem;margin:0 0 24px;color:#9fd8cf}"
    ".button{display:inline-block;padding:12px 28px;border-radius:999px;"
    "background:#2dd4bf;color:#05211d;text-decoration:none;font-weight:600;"
    "transition:transform .15s ease}"
    ".button:hover{transform:translateY(-2px)}".
