# an example helper to provide DBus sessions
{ pkgs ? import ../../default.nix {} }:
pkgs.makeSetupHook {
  substitutions = { inherit (pkgs) dbus; };
} ./dbus.sh
