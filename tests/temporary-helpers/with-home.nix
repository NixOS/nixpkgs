# an example helper to set HOME
{ pkgs ? import ../../default.nix {} }:
pkgs.makeSetupHook {} (pkgs.writeText "home-hook.sh"
  ''export HOME="$PWD/home"; mkdir -p "$HOME";'')
