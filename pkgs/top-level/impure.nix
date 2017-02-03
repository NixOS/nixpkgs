/* Impure default args for `pkgs/top-level/default.nix`. See that file
   for the meaning of each argument. */

with builtins;

let

  homeDir = builtins.getEnv "HOME";

  # Return ‘x’ if it evaluates, or ‘def’ if it throws an exception.
  try = x: def: let res = tryEval x; in if res.success then res.value else def;

in

{ # Fallback: Assume we are building packages for the current (host, in GNU
  # Autotools parlance) system.
  system ? builtins.currentSystem

, # Fallback: The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.config/nixpkgs/config.nix.
  config ? let
      configFile = getEnv "NIXPKGS_CONFIG";
      configFile2 = homeDir + "/.config/nixpkgs/config.nix";
      configFile3 = homeDir + "/.nixpkgs/config.nix"; # obsolete
    in
      if configFile != "" && pathExists configFile then import configFile
      else if homeDir != "" && pathExists configFile2 then import configFile2
      else if homeDir != "" && pathExists configFile3 then import configFile3
      else {}

, # Overlays are used to extend Nixpkgs collection with additional
  # collections of packages.  These collection of packages are part of the
  # fix-point made by Nixpkgs.
  overlays ? let
      dirPath = try (if pathExists <nixpkgs-overlays> then <nixpkgs-overlays> else "") "";
      dirHome = homeDir + "/.config/nixpkgs/overlays";
      dirCheck = dir: dir != "" && pathExists (dir + "/.");
      overlays = dir:
        let content = readDir dir; in
        map (n: import (dir + ("/" + n)))
          (builtins.filter (n: builtins.match ".*\.nix" n != null)
            (attrNames content));
    in
      if dirPath != "" then
        overlays dirPath
      else if dirCheck dirHome then overlays dirHome
      else []

, ...
} @ args:

import ./. (args // { inherit system config overlays; })
