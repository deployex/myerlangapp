%%%-------------------------------------------------------------------
%% @doc myerlangapp counter server.
%%
%% Holds a single integer counter in its state. 0.2.1 added
%% code_change/3 as a no-op, purely so a running 0.2.1 would be a
%% valid baseline for this: rebar3_jellyfish_plugin decides the
%% instruction it generates for a module from the currently-deployed
%% version's own exports, not the incoming one, so an upgrade away
%% from 0.2.0 (which exports no code_change/3) could never use the
%% advanced/code_change path regardless of what the target added.
%% 0.2.2 is the payoff: upgrading from 0.2.1 onward now runs the
%% print below for real, instead of a plain load_module.
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_server).

-behaviour(gen_server).

-export([start_link/0, bump/0, bump/1, get_count/0, reset/0]).
-export([init/1, handle_call/3, handle_cast/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {count = 0 :: non_neg_integer()}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

bump() ->
    bump(1).

bump(N) when is_integer(N), N > 0 ->
    gen_server:call(?SERVER, {bump, N}).

get_count() ->
    gen_server:call(?SERVER, get_count).

reset() ->
    gen_server:call(?SERVER, reset).

init([]) ->
    {ok, #state{}}.

handle_call({bump, N}, _From, State = #state{count = Count}) ->
    NewCount = Count + N,
    myerlangapp_history_server:record_bump(),
    {reply, NewCount, State#state{count = NewCount}};
handle_call(get_count, _From, State = #state{count = Count}) ->
    {reply, Count, State};
handle_call(reset, _From, State) ->
    {reply, ok, State#state{count = 0}}.

handle_cast(_Msg, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    io:format("( ͡° ͜ʖ ͡°)_/¯ myerlangapp just hot-upgraded itself, counter kept intact~n"),
    {ok, State}.
