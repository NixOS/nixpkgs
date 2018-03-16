# an example heler to provide fonts.conf
{ pkgs ? import ../../default.nix {}, fonts ? [] }:
pkgs.makeSetupHook {} (pkgs.writeText "home-hook.sh"
  ''
    export FONTCONFIG_FILE="${pkgs.makeFontsConf {
      fontDirectories = pkgs.lib.optCall fonts pkgs;
    }}"
  '')
