-module(erd_dice_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-export([start_dice/0, start_shell/0, dice_nodes/0]).

dice_nodes() ->
  [ { P, node( P ) } || P <- resource_discovery:get_resources(die) ].

start_shell() ->
  resource_discovery:add_target_resource_type( die ),
  resource_discovery:trade_resources(),
  dice_nodes().

start_dice() ->
  net_kernel:connect_node( 'erd_dice1@Holly' ),
  start_dice( 16 ),
  resource_discovery:trade_resources().

start_dice( 0 ) ->
  ok;
start_dice( N ) when is_integer( N ) ->
  { ok, P } = erd_dice_sup:start_die(),
  resource_discovery:add_local_resource_tuple( { die, P } ),
  start_dice( N - 1 ).

start(_Type, _Args) ->
  net_kernel:connect_node( 'erd_dice1@Holly' ),

  resource_discovery:add_local_resource_tuple( { node, node() } ),
  resource_discovery:trade_resources(),
  
  [ net_kernel:connect_node( X ) || X <- resource_discovery:get_resources( node ) ],

  resource_discovery:trade_resources(),

	erd_dice_sup:start_link().

stop(_State) ->
	ok.
