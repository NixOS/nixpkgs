/* Impure default args for `pkgs/top-level/default.nix`. See that file
   for the meaning of each argument. */

{ # Fallback: Assume we are building packages for the current (host, in GNU
  # Autotools parlance) system.
  system ? builtins.currentSystem

, # Fallback: The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  config ? let
      inherit (builtins) getEnv pathExists;

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";
    in
      if configFile != "" && pathExists configFile then import configFile
      else if homeDir != "" && pathExists configFile2 then import configFile2
      else {}

, ...
} @ args:

import ./. (args // { inherit system config; })
