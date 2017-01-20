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

, # Overlays are used to extend Nixpkgs collection with additional
  # collections of packages.  These collection of packages are part of the
  # fix-point made by Nixpkgs.
  overlays ? let
      inherit (builtins) getEnv pathExists readDir attrNames map sort
        lessThan;
      dirEnv = getEnv "NIXPKGS_OVERLAYS";
      dirHome = (getEnv "HOME") + "/.nixpkgs/overlays";
      dirCheck = dir: dir != "" && pathExists (dir + "/.");
      overlays = dir:
        let content = readDir dir; in
        map (n: import "${dir}/${n}") (sort lessThan (attrNames content));
    in
      if dirEnv != "" then
        if dirCheck dirEnv then overlays dirEnv
        else throw "The environment variable NIXPKGS_OVERLAYS does not name a valid directory."
      else if dirCheck dirHome then overlays dirHome
      else []

, ...
} @ args:

import ./. (args // { inherit system config overlays; })
