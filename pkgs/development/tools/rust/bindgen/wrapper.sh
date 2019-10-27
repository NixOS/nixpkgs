#!/usr/bin/env bash
sep='--'   # whether to add -- before new options
cxx=0      # whether cxx was explicitly requested
lastWasx=0 # whether the last argument passed was -x
for e in "$@"; do
  if [[ "$e" == "--" ]]; then
    sep=
  fi;
  if [[ "$sep" == "" ]]; then
    # we look for -x c++ after -- only
    if [[ "$e" == "-x" ]]; then
      lastWasx=1
    fi;
    if [[ $lastWasx -eq 1 && "$e" == "c++" ]]; then
      lastWasx=0
      cxx=1
    fi;
    if [[ "$e" == "-xc++" || "$e" == -std=c++* ]]; then
      cxx=1
    fi;
  fi;
done;
cxxflags=
if [[ $cxx -eq 1 ]]; then
  cxxflags=$NIX_CXXSTDLIB_COMPILE
fi;
if [[ -n "$NIX_DEBUG" ]]; then
  set -x;
fi;
export LIBCLANG_PATH="@libclang@/lib"
# shellcheck disable=SC2086
# cxxflags and NIX_CFLAGS_COMPILE should be word-split
exec -a "$0" @out@/bin/.bindgen-wrapped "$@" $sep $cxxflags $NIX_CFLAGS_COMPILE
# note that we add the flags after $@ which is incorrect. This is only for the sake
# of simplicity.

