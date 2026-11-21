%%%-------------------------------------------------------------------
%% @doc Minimal HTTP listener for myerlangapp.
%%
%% No HTTP framework dependency on purpose: this project exists to
%% exercise rebar3_jellyfish_plugin's appup generation, so staying
%% dependency-free keeps the beam diffs small and predictable.
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_listener).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-define(DEFAULT_PORT, 8080).
-define(ACCEPT_TIMEOUT, 1000).
-define(RECV_TIMEOUT, 5000).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Port = get_port(),
    {ok, ListenSocket} = gen_tcp:listen(Port, [
        binary,
        {packet, http_bin},
        {active, false},
        {reuseaddr, true}
    ]),
    gen_server:cast(self(), accept),
    {ok, ListenSocket}.

handle_cast(accept, ListenSocket) ->
    case gen_tcp:accept(ListenSocket, ?ACCEPT_TIMEOUT) of
        {ok, Socket} ->
            handle_connection(Socket);
        {error, timeout} ->
            ok;
        {error, _Reason} ->
            ok
    end,
    gen_server:cast(self(), accept),
    {noreply, ListenSocket}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_info(_Info, State) ->
    {noreply, State}.

%% internal functions

%% DeployEx injects the PORT environment variable per replica (see
%% replica_ports in deployex.yaml/dev.override.exs). Falling back to the
%% sys.config/app env value keeps this runnable outside DeployEx too.
get_port() ->
    case os:getenv("PORT") of
        false -> application:get_env(myerlangapp, port, ?DEFAULT_PORT);
        PortStr -> list_to_integer(PortStr)
    end.

handle_connection(Socket) ->
    case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of
        {ok, {http_request, Method, Path, _Version}} ->
            consume_headers(Socket),
            respond(Socket, Method, Path);
        _ ->
            ok
    end,
    gen_tcp:close(Socket).

consume_headers(Socket) ->
    case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of
        {ok, {http_header, _, _, _, _}} ->
            consume_headers(Socket);
        _ ->
            ok
    end.

respond(Socket, 'GET', {abs_path, <<"/">>}) ->
    Count = myerlangapp_server:get_count(),
    Bumps = myerlangapp_history_server:get_bumps(),
    send_html(Socket, 200, myerlangapp_page:render(Count, Bumps));
respond(Socket, 'GET', {abs_path, <<"/bump">>}) ->
    myerlangapp_server:bump(),
    send_redirect(Socket, "/");
respond(Socket, _Method, _Path) ->
    send_html(Socket, 404, myerlangapp_page:not_found()).

send_html(Socket, Status, Body) ->
    Response = [
        status_line(Status),
        "\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: ",
        integer_to_list(byte_size(Body)),
        "\r\nConnection: close\r\n\r\n",
        Body
    ],
    gen_tcp:send(Socket, Response).

send_redirect(Socket, Location) ->
    Response = [
        "HTTP/1.1 302 Found\r\nLocation: ",
        Location,
        "\r\nContent-Length: 0\r\nConnection: close\r\n\r\n"
    ],
    gen_tcp:send(Socket, Response).

status_line(200) -> "HTTP/1.1 200 OK";
status_line(404) -> "HTTP/1.1 404 Not Found".
