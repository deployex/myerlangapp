%%%-------------------------------------------------------------------
%% @doc myerlangapp counter server.
%%
%% Holds a single integer counter in its state. Kept deliberately
%% simple in 0.1.0 so that changing its state shape in a later version
%% gives rebar3_jellyfish_plugin a real code_change to generate.
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_server).

-behaviour(gen_server).

-export([start_link/0, bump/0, bump/1, get_count/0, reset/0]).
-export([init/1, handle_call/3, handle_cast/2]).

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
    {reply, NewCount, State#state{count = NewCount}};
handle_call(get_count, _From, State = #state{count = Count}) ->
    {reply, Count, State};
handle_call(reset, _From, State) ->
    {reply, ok, State#state{count = 0}}.

handle_cast(_Msg, State) ->
    {noreply, State}.
