-module(erd_dice_die).
-behaviour(gen_server).

%% API.
-export([start_link/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-export([roll/1]).

-record(state, {
}).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link(?MODULE, [], []).

roll( Pid ) ->
  gen_server:call( Pid, roll ).

%% gen_server.

init([]) ->
  io:format("Dice Started ~p~n", [ self() ] ),
	{ok, #state{}}.

handle_call( roll, _From, State ) ->
  random:seed(now()),
  { reply, random:uniform( 6 ), State };
handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
