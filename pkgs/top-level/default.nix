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

{ # The system (e.g., `i686-linux') for which to build the packages.
  system

, # Allow a configuration attribute set to be passed in as an argument.
  config ? {}

, # List of overlays layers used to extend Nixpkgs.
  overlays ? []

, # A function booting the final package set for a specific standard
  # environment. See below for the arguments given to that function,
  # the type of list it returns.
  stdenvStages ? import ../stdenv

, crossSystem ? null
, platform ? assert false; null
} @ args:

let # Rename the function arguments
  configExpr = config;

in let
  lib = import ../../lib;

  # Allow both:
  # { /* the config */ } and
  # { pkgs, ... } : { /* the config */ }
  config =
    if builtins.isFunction configExpr
    then configExpr { inherit pkgs; }
    else configExpr;

  # Allow setting the platform in the config file. Otherwise, let's use a
  # reasonable default.
  platform =
    args.platform
    or ( config.platform
      or ((import ./platforms.nix).selectPlatformBySystem system) );

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
  # want the provided non-native `system` argument to affect the stdenv chosen.
  nixpkgsFun = newArgs: import ./. (args // newArgs);

  # Partially apply some arguments for building bootstraping stage pkgs
  # sets. Only apply arguments which no stdenv would want to override.
  allPackages = newArgs: import ./stage.nix ({
    inherit lib nixpkgsFun;
  } // newArgs);

  boot = import ../stdenv/booter.nix { inherit lib allPackages; };

  stages = stdenvStages {
    # One would think that `localSystem` and `crossSystem` overlap horribly with
    # the three `*Platforms` (`buildPlatform`, `hostPlatform,` and
    # `targetPlatform`; see `stage.nix` or the manual). Actually, those
    # identifiers I, @Ericson2314, purposefully not used here to draw a subtle
    # but important distinction:
    #
    # While the granularity of having 3 platforms is necessary to properly
    # *build* packages, it is overkill for specifying the user's *intent* when
    # making a build plan or package set. A simple "build vs deploy" dichotomy
    # is adequate: the "sliding window" principle described in the manual shows
    # how to interpolate between the these two "end points" to get the 3
    # platform triple for each bootstrapping stage.
    #
    # Also, less philosophically but quite practically, `crossSystem` should be
    # null when one doesn't want to cross-compile, while the `*Platform`s are
    # always non-null. `localSystem` is always non-null.
    localSystem = { inherit system platform; };
    inherit lib crossSystem config overlays;
  };

  pkgs = boot stages;

in pkgs
