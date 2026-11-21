%%%-------------------------------------------------------------------
%% @doc myerlangapp top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(myerlangapp_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy => one_for_one,
        intensity => 1,
        period => 5
    },
    ChildSpecs = [
        #{
            id => myerlangapp_history_server,
            start => {myerlangapp_history_server, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [myerlangapp_history_server]
        },
        #{
            id => myerlangapp_server,
            start => {myerlangapp_server, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [myerlangapp_server]
        },
        #{
            id => myerlangapp_listener,
            start => {myerlangapp_listener, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [myerlangapp_listener]
        }
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
