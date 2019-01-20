/* This function composes the Nix Packages collection. It:

     1. Applies the final stage to the given `config` if it is a function

     2. Infers an appropriate `platform` based on the `system` if none is
        provided

     3. Defaults to no non-standard config and no cross-compilation target

     4. Uses the above to infer the default standard environment's (stdenv's)
        stages if no stdenv's are provided

     5. Folds the stages to yield the final fully booted package set for the
        chosen stdenv

   Use `impure.nix` to also infer the `system` based on the one on which
   evaluation is taking place, and the configuration from environment variables
   or dot-files. */

{ # The system packages will be built on. See the manual for the
  # subtle division of labor between these two `*System`s and the three
  # `*Platform`s.
  localSystem

, # The system packages will ultimately be run on.
  crossSystem ? localSystem

, # Allow a configuration attribute set to be passed in as an argument.
  config ? {}

, # List of overlays layers used to extend Nixpkgs.
  overlays ? []

, # List of overlays to apply to target packages only.
  crossOverlays ? []

, # A function booting the final package set for a specific standard
  # environment. See below for the arguments given to that function, the type of
  # list it returns.
  stdenvStages ? import ../stdenv
} @ args:

let # Rename the function arguments
  configExpr = config;
  crossSystem0 = crossSystem;

in let
  lib = import ../../lib;

  # Allow both:
  # { /* the config */ } and
  # { pkgs, ... } : { /* the config */ }
  config =
    if lib.isFunction configExpr
    then configExpr { inherit pkgs; }
    else configExpr;

  # From a minimum of `system` or `config` (actually a target triple, *not*
  # nixpkgs configuration), infer the other one and platform as needed.
  localSystem = lib.systems.elaborate (
    # Allow setting the platform in the config file. This take precedence over
    # the inferred platform, but not over an explicitly passed-in one.
    builtins.intersectAttrs { platform = null; } config
    // args.localSystem);

  crossSystem = if crossSystem0 == null then localSystem
                else lib.systems.elaborate crossSystem0;

  # A few packages make a new package set to draw their dependencies from.
  # (Currently to get a cross tool chain, or forced-i686 package.) Rather than
  # give `all-packages.nix` all the arguments to this function, even ones that
  # don't concern it, we give it this function to "re-call" nixpkgs, inheriting
  # whatever arguments it doesn't explicitly provide. This way,
  # `all-packages.nix` doesn't know more than it needs too.
  #
  # It's OK that `args` doesn't include default arguemtns from this file:
  # they'll be deterministically inferred. In fact we must *not* include them,
  # because it's important that if some parameter which affects the default is
  # substituted with a different argument, the default is re-inferred.
  #
  # To put this in concrete terms, this function is basically just used today to
  # use package for a different platform for the current platform (namely cross
  # compiling toolchains and 32-bit packages on x86_64). In both those cases we
  # want the provided non-native `localSystem` argument to affect the stdenv
  # chosen.
  nixpkgsFun = newArgs: import ./. (args // newArgs);

  # Partially apply some arguments for building bootstraping stage pkgs
  # sets. Only apply arguments which no stdenv would want to override.
  allPackages = newArgs: import ./stage.nix ({
    inherit lib nixpkgsFun;
  } // newArgs);

  boot = import ../stdenv/booter.nix { inherit lib allPackages; };

  stages = stdenvStages {
    inherit lib localSystem crossSystem config overlays crossOverlays;
  };

  pkgs = boot stages;

in pkgs
