%% This module, when loaded as a plugin, overrides the default `install_deps`
%% provider and erases the dependencies from the rebar3 state, when
%% REBAR_IGNORE_DEPS is true.

-module(rebar_ignore_deps).

-export([init/1, do/1, format_error/1]).

init(State0) ->
    case os:getenv("REBAR_IGNORE_DEPS", "") of
        "" ->
            {ok, State0};
        _ ->
            do_init(State0)
    end.

do_init(State0) ->
    State1 = rebar_state:allow_provider_overrides(State0, true),
    Provider = providers:create(
                 [
                  {name, install_deps}, %% override the default install_deps provider
                  {module, ?MODULE},
                  {bare, false},
                  {deps, [app_discovery]},
                  {example, undefined},
                  {opts, []},
                  {short_desc, ""},
                  {desc, ""}
                 ]),
    State2 = rebar_state:add_provider(State1, Provider),
    {ok, rebar_state:allow_provider_overrides(State2, false)}.

do(State0) ->
    io:format("Ignoring deps...~n"),
    Profiles = rebar_state:current_profiles(State0),
    State = lists:foldl(fun(P, Acc0) ->
                                 Acc = rebar_state:set(Acc0, {deps, P}, []),
                                 rebar_state:set(Acc, {parsed_deps, P}, [])
                         end, State0, Profiles),
    {ok, State}.

format_error(Reason) ->
    io_lib:format("~p", [Reason]).
