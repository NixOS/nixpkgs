/* Impure default args for `pkgs/top-level/default.nix`. See that file
   for the meaning of each argument. */

with builtins;

let

  homeDir = getEnv "HOME";

  # Return ‘x’ if it evaluates, or ‘def’ if it throws an exception.
  try = x: def: let res = tryEval x; in if res.success then res.value else def;

  configFile  = getEnv "NIXPKGS_CONFIG";
  configFile2 = homeDir + "/.config/nixpkgs/config.nix";
  configFile3 = homeDir + "/.nixpkgs/config.nix"; # obsolete

  mkConfigs = config:
    if config != null then [ { file = "nixpkgs.config-argument"; value = config; } ]
    else if configFile != "" && pathExists configFile  then [ configFile  ]
    else if homeDir    != "" && pathExists configFile2 then [ configFile2 ]
    else if homeDir    != "" && pathExists configFile3 then [ configFile3 ]
    else [];

  isDir = path: pathExists (path + "/.");
  pathOverlays = try (toString <nixpkgs-overlays>) "";
  homeOverlaysFile = homeDir + "/.config/nixpkgs/overlays.nix";
  homeOverlaysDir = homeDir + "/.config/nixpkgs/overlays";
  importOverlays = path:
    # check if the path is a directory or a file
    if isDir path then
      # it's a directory, so the set of overlays from the directory, ordered lexicographically
      let content = readDir path; in
      map (n: import (path + ("/" + n)))
        (filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix")))
          (attrNames content))
    else
      # it's a file, so the result is the contents of the file itself
      import path;

  overlays_ =
    if pathOverlays != "" && pathExists pathOverlays then importOverlays pathOverlays
    else if pathExists homeOverlaysFile && pathExists homeOverlaysDir then
      throw ''
        Nixpkgs overlays can be specified with ${homeOverlaysFile} or ${homeOverlaysDir}, but not both.
        Please remove one of them and try again.
      ''
    else if pathExists homeOverlaysFile then
      if isDir homeOverlaysFile then
        throw (homeOverlaysFile + " should be a file")
      else importOverlays homeOverlaysFile
    else if pathExists homeOverlaysDir then
      if !(isDir homeOverlaysDir) then
        throw (homeOverlaysDir + " should be a directory")
      else importOverlays homeOverlaysDir
    else [];

in

{ # We combine legacy `system` and `platform` into `localSystem`, if
  # `localSystem` was not passed. Strictly speaking, this is pure desugar, but
  # it is most convient to do so before the impure `localSystem.system` default,
  # so we do it now.
  localSystem ? intersectAttrs { system = null; platform = null; } args

, # These are needed only because nix's `--arg` command-line logic doesn't work
  # with unnamed parameters allowed by ...
  system ? localSystem.system
, platform ? localSystem.platform
, crossSystem ? null

, # Fallback: The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.config/nixpkgs/config.nix.
  config ? null

, # This is what actually gets evaluated for config.
  configs ? mkConfigs config

, # Overlays are used to extend Nixpkgs collection with additional
  # collections of packages.  These collection of packages are part of the
  # fix-point made by Nixpkgs.
  overlays ? overlays_

, ...
} @ args:

# If `localSystem` was explicitly passed, legacy `system` and `platform` should
# not be passed.
assert args ? localSystem -> !(args ? system || args ? platform);

import ./. (removeAttrs args [ "system" "platform" "config" ] // {
  inherit configs overlays crossSystem;
  # Fallback: Assume we are building packages on the current (build, in GNU
  # Autotools parlance) system.
  localSystem = (if args ? localSystem then {}
                 else { system = builtins.currentSystem; }) // localSystem;
})
