/*
  Impure default args for `pkgs/top-level/default.nix`. See that file
  for the meaning of each argument.
*/

let

  homeDir = builtins.getEnv "HOME";

in

{
  # We put legacy `system` into `localSystem`, if `localSystem` was not passed.
  # If neither is passed, assume we are building packages on the current
  # (build, in GNU Autotools parlance) platform.
  localSystem ? {
    system = args.system or builtins.currentSystem;
  },

  # These are needed only because nix's `--arg` command-line logic doesn't work
  # with unnamed parameters allowed by ...
  system ? localSystem.system,
  crossSystem ? localSystem,

  # Fallback: The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.config/nixpkgs/config.nix.
  config ?
    let
      configFile = builtins.getEnv "NIXPKGS_CONFIG";
      configFile2 = homeDir + "/.config/nixpkgs/config.nix";
      configFile3 = homeDir + "/.nixpkgs/config.nix"; # obsolete
    in
    if configFile != "" && builtins.pathExists configFile then
      import configFile
    else if homeDir != "" && builtins.pathExists configFile2 then
      import configFile2
    else if homeDir != "" && builtins.pathExists configFile3 then
      import configFile3
    else
      { },

  # Overlays are used to extend Nixpkgs collection with additional
  # collections of packages.  These collection of packages are part of the
  # fix-point made by Nixpkgs.
  overlays ? import ./impure-overlays.nix,

  crossOverlays ? [ ],

  ...
}@args:

# If `localSystem` was explicitly passed, legacy `system` should
# not be passed, and vice-versa.
assert args ? localSystem -> !(args ? system);
assert args ? system -> !(args ? localSystem);

import ./. (
  builtins.removeAttrs args [ "system" ]
  // {
    inherit config overlays localSystem;
  }
)
