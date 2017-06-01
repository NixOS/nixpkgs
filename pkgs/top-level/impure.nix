/* Impure default args for `pkgs/top-level/default.nix`. See that file
   for the meaning of each argument. */

with builtins;

let

  homeDir = builtins.getEnv "HOME";

  # Return ‘x’ if it evaluates, or ‘def’ if it throws an exception.
  try = x: def: let res = tryEval x; in if res.success then res.value else def;

in

{ # We combine legacy `system` and `platform` into `localSystem`, if
  # `localSystem` was not passed. Strictly speaking, this is pure desugar, but
  # it is most convient to do so before the impure `localSystem.system` default,
  # so we do it now.
  localSystem ? builtins.intersectAttrs { system = null; platform = null; } args

, # These are needed only because nix's `--arg` command-line logic doesn't work
  # with unnamed parameters allowed by ...
  system ? localSystem.system
, platform ? localSystem.platform
, crossSystem ? null

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
          (builtins.filter (n: builtins.match ".*\.nix" n != null || pathExists (dir + ("/" + n + "/default.nix")))
            (attrNames content));
    in
      if dirPath != "" then
        overlays dirPath
      else if dirCheck dirHome then overlays dirHome
      else []

, ...
} @ args:

# If `localSystem` was explicitly passed, legacy `system` and `platform` should
# not be passed.
assert args ? localSystem -> !(args ? system || args ? platform);

import ./. (builtins.removeAttrs args [ "system" "platform" ] // {
  inherit config overlays crossSystem;
  # Fallback: Assume we are building packages on the current (build, in GNU
  # Autotools parlance) system.
  localSystem = { system = builtins.currentSystem; } // localSystem;
})
