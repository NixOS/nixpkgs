/*
  Impure default args for `pkgs/top-level/default.nix`. See that file
  for the meaning of each argument.
*/

let

  homeDir = builtins.getEnv "HOME";

in

{
  # Where the packages will run
  hostPlatform ?
    # unreachable
    abort
      "argument `hostPlatform` is optional in top-level/impure.nix, but has no default, because it and related arguments are processed in top-level/default.nix instead",
  # Where the derivations are built
  buildPlatform ?
    # unreachable
    abort
      "argument `buildPlatform` is optional in top-level/impure.nix, but has no default, because it and related arguments are processed in top-level/default.nix instead",

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

  ...
}@args:

# If `localSystem` was explicitly passed, legacy `system` should
# not be passed, and vice-versa.
assert args ? localSystem -> !(args ? system);
assert args ? system -> !(args ? localSystem);

# # Similarly for more recently soft-deprecated parameters, in which case we
# # don't want to mix and match:
# # Either use the pre 24.11 legacy attrs, or {host,build}Platform.
# assert (args ? localSystem || args ? system || args ? crossSystem) != (args ? hostPlatform || args ? buildPlatform);
let
  # If legacy args are passed, we need to perform the localSystem default logic here.
  # If they are not passed,
  hasLegacyArgs = args ? system || args ? localSystem || args ? crossSystem;
  impureArgs =
    !args ? system
    && !args ? localSystem
    && !args ? crossSystem
    && !args ? hostPlatform
    && !args ? buildPlatform;
in

import ./. (
  removeAttrs args [ "system" ]
  // {
    inherit config overlays;
  }
  // (
    if hasLegacyArgs || impureArgs then
      {
        # default.nix is a bit simpler than impure.nix (here), as we only perform the
        # defaulting behavior here...
        inherit localSystem;
      }
    else
      {
        # ... however, for the new {host,build}Platform, we
        # don't want to trigger the checks in default.nix or weaken those checks.
      }
  )
)
