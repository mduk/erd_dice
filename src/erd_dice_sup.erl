-module(erd_dice_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-export([start_die/0]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_die() ->
  Mfa = { erd_dice_die, start_link, [] },
	ChildSpec = { now(), Mfa, permanent, 5000, worker, [ erd_dice_die ] },
  supervisor:start_child( ?MODULE, ChildSpec ).

init([]) ->
	Procs = [],
	{ok, {{one_for_one, 1, 5}, Procs}}.
