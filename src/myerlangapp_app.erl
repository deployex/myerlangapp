%%%-------------------------------------------------------------------
%% @doc myerlangapp public API
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    myerlangapp_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
