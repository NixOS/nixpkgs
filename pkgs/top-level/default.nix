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
  crossSystem

, # List of configuration modules to apply.
  configs ? []

, # List of overlays layers used to extend Nixpkgs.
  overlays ? []

, # List of overlays to apply to target packages only.
  crossOverlays ? []

, # A function booting the final package set for a specific standard
  # environment. See below for the arguments given to that function, the type of
  # list it returns.
  stdenvStages ? import ../stdenv
} @ args:

let
  lib = import ../../lib;

  # Massage e into a NixOS module.
  mkModule = e: { options, ... }@args:
    let
      # We need all this stuff only because we want to support unknown options,
      # without them this can be simplified a lot.
      unify = file: value: lib.unifyModuleSyntax file file (lib.applyIfFunction file value args);

      fake = "nixpkgs.configs element";
      module =
        if lib.isFunction e then unify fake e # { ... }: config
        else if lib.isAttrs e then
          (if e ? file && e ? value then unify e.file e.value # types.opaque
           else unify fake e) # plain config
        else unify (toString e) (import e); # path

      # a bit of magic to move all options unknown to the ./config.nix
      # under "unknowns" option so that the module checker won't complain
      # FIXME: remove this eventually
      configWithoutUnknowns = builtins.intersectAttrs options module.config // {
        unknowns = lib.filterAttrs (n: v: !(options ? ${n})) module.config;
      };
    in module // {
      config = configWithoutUnknowns;
    };

  # Eval configs.
  configEval = lib.evalModules {
    modules = [
      {
        _module.args = { inherit pkgs; };
      }
      {
        inherit localSystem crossSystem;
      }
      ./config.nix
    ] ++ map mkModule configs;
  };

  # Do the reverse of configWithoutUnknowns.
  configWithUnknowns = configEval.config // configEval.config.unknowns;

  config = lib.showWarnings configEval.config.warnings configWithUnknowns;

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

  # Partially apply some arguments for building bootstraping stage pkgs
  # sets. Only apply arguments which no stdenv would want to override.
  allPackages = newArgs: import ./stage.nix ({
    inherit lib nixpkgsFun;
    inherit (config) extraScope;
  } // newArgs);

  boot = import ../stdenv/booter.nix { inherit lib allPackages; };

  stages = stdenvStages {
    inherit lib config overlays crossOverlays;
    inherit (config) localSystem crossSystem;
  };

  pkgs = boot stages;

in pkgs
