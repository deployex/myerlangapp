%%%-------------------------------------------------------------------
%% @doc myerlangapp bump history.
%%
%% Added in 0.2.0: a new supervised child, independent from
%% myerlangapp_server's own state, so this release's appup exercises
%% add_module and a supervisor update instead of a state_change
%% migration - myerlangapp_server doesn't export code_change/3 in
%% 0.1.0, so a running 0.1.0 process would never actually invoke one
%% generated against it (the instruction type an upgrade uses is
%% chosen from the currently-deployed version's own exports, not the
%% incoming one).
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_history_server).

-behaviour(gen_server).

-export([start_link/0, record_bump/0, get_bumps/0]).
-export([init/1, handle_call/3, handle_cast/2]).

-define(SERVER, ?MODULE).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

record_bump() ->
    gen_server:cast(?SERVER, record_bump).

get_bumps() ->
    gen_server:call(?SERVER, get_bumps).

init([]) ->
    {ok, 0}.

handle_call(get_bumps, _From, Bumps) ->
    {reply, Bumps, Bumps}.

handle_cast(record_bump, Bumps) ->
    {noreply, Bumps + 1}.
