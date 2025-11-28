/*
  This function composes the Nix Packages collection. It:

    1. Elaborates `localSystem` and `crossSystem` with defaults as needed.

    2. Applies the final stage to the given `config` if it is a function

    3. Defaults to no non-standard config and no cross-compilation target

    4. Uses the above to infer the default standard environment's (stdenv's)
       stages if no stdenv's are provided

    5. Folds the stages to yield the final fully booted package set for the
       chosen stdenv

  Use `impure.nix` to also infer the `system` based on the one on which
  evaluation is taking place, and the configuration from environment variables
  or dot-files.
*/

{
  # The system packages will be built on. See the manual for the
  # subtle division of labor between these two `*System`s and the three
  # `*Platform`s.
  localSystem,

  # The system packages will ultimately be run on.
  crossSystem ? localSystem,

  # Allow a configuration module to be passed in as an argument.
  config ? { },

  # Temporary hack to let Nixpkgs forbid internal use of `lib.fileset`
  # until <https://github.com/NixOS/nix/issues/11503> is fixed.
  __allowFileset ? true,

  # List of overlays layers used to extend Nixpkgs.
  overlays ? [ ],

  # List of overlays to apply to target packages only.
  crossOverlays ? [ ],

  # A function booting the final package set for a specific standard
  # environment. See below for the arguments given to that function, the type of
  # list it returns.
  stdenvStages ? import ../stdenv,

  # Ignore unexpected args.
  ...
}@args:

let # Rename the function arguments
  config0 = config;
  crossSystem0 = crossSystem;

in
let
  pristineLib = import ../../lib;

  lib =
    if __allowFileset then
      pristineLib
    else
      pristineLib.extend (
        _: _: {
          fileset = abort ''

            The use of `lib.fileset` is currently forbidden in Nixpkgs due to the
            upstream Nix bug <https://github.com/NixOS/nix/issues/11503>. This
            causes difficult‐to‐debug errors when combined with chroot stores,
            such as in the NixOS installer.

            For packages that require source to be vendored inside Nixpkgs,
            please use a subdirectory of the package instead.
          '';
        }
      );

  inherit (lib) throwIfNot;

  checked =
    (throwIfNot (lib.isList overlays) "The overlays argument to nixpkgs must be a list.")
      (throwIfNot (lib.all lib.isFunction overlays) "All overlays passed to nixpkgs must be functions.")
      (throwIfNot (lib.isList crossOverlays) "The crossOverlays argument to nixpkgs must be a list.")
      (
        throwIfNot (lib.all lib.isFunction crossOverlays) "All crossOverlays passed to nixpkgs must be functions."
      );

  localSystem = lib.systems.elaborate args.localSystem;

  # Condition preserves sharing which in turn affects equality.
  #
  # See `lib.systems.equals` documentation for more details.
  #
  # Note that it is generally not possible to compare systems as given in
  # parameters, e.g. if systems are initialized as
  #
  #   localSystem = { system = "x86_64-linux"; };
  #   crossSystem = { config = "x86_64-unknown-linux-gnu"; };
  #
  # Both systems are semantically equivalent as the same vendor and ABI are
  # inferred from the system double in `localSystem`.
  crossSystem =
    let
      system = lib.systems.elaborate crossSystem0;
    in
    if crossSystem0 == null || lib.systems.equals system localSystem then localSystem else system;

  configEval = lib.evalModules {
    modules = [
      ./config.nix
      (lib.modules.setDefaultModuleLocation "nixpkgs.config" config0)
    ];
    specialArgs = { inherit pkgs; };
    class = "nixpkgsConfig";
  };

  # take all the rest as-is
  config = lib.showWarnings configEval.config.warnings configEval.config;

  # A few packages make a new package set to draw their dependencies from.
  # (Currently to get a cross tool chain, or forced-i686 package.) Rather than
  # give `all-packages.nix` all the arguments to this function, even ones that
  # don't concern it, we give it this function to "re-call" nixpkgs, inheriting
  # whatever arguments it doesn't explicitly provide. This way,
  # `all-packages.nix` doesn't know more than it needs too.
  #
  # It's OK that `args` doesn't include default arguments from this file:
  # they'll be deterministically inferred. In fact we must *not* include them,
  # because it's important that if some parameter which affects the default is
  # substituted with a different argument, the default is re-inferred.
  #
  # To put this in concrete terms, this function is basically just used today to
  # use package for a different platform for the current platform (namely cross
  # compiling toolchains and 32-bit packages on x86_64). In both those cases we
  # want the provided non-native `localSystem` argument to affect the stdenv
  # chosen.
  #
  # NB!!! This thing gets its `config` argument from `args`, i.e. it's actually
  # `config0`. It is important to keep it to `config0` format (as opposed to the
  # result of `evalModules`, i.e. the `config` variable above) throughout all
  # nixpkgs evaluations since the above function `config0 -> config` implemented
  # via `evalModules` is not idempotent. In other words, if you add `config` to
  # `newArgs`, expect strange very hard to debug errors! (Yes, I'm speaking from
  # experience here.)
  nixpkgsFun = newArgs: import ./. (args // newArgs);

  # Partially apply some arguments for building bootstrapping stage pkgs
  # sets. Only apply arguments which no stdenv would want to override.
  allPackages =
    newArgs:
    import ./stage.nix (
      {
        inherit lib nixpkgsFun;
      }
      // newArgs
    );

  boot = import ../stdenv/booter.nix { inherit lib allPackages; };

  stages = stdenvStages {
    inherit
      lib
      localSystem
      crossSystem
      config
      overlays
      crossOverlays
      ;
  };

  pkgs = boot stages;

in
checked pkgs
