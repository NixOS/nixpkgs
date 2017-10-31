/* This file composes a single bootstrapping stage of the Nix Packages
   collection. That is, it imports the functions that build the various
   packages, and calls them with appropriate arguments. The result is a set of
   all the packages in the Nix Packages collection for some particular platform
   for some particular stage.

   Default arguments are only provided for bootstrapping
   arguments. Normal users should not import this directly but instead
   import `pkgs/default.nix` or `default.nix`. */


{ ## Misc parameters kept the same for all stages
  ##

  # Utility functions, could just import but passing in for efficiency
  lib

, # Use to reevaluate Nixpkgs; a dirty hack that should be removed
  nixpkgsFun

  ## Other parameters
  ##

, # The package set used at build-time. If null, `buildPackages` will
  # be defined internally as the final produced package set itself. This allows
  # us to avoid expensive splicing.
  buildPackages

, # The package set used in the next stage. If null, `__targetPackages` will be
  # defined internally as the final produced package set itself, just like with
  # `buildPackages` and for the same reasons.
  #
  # THIS IS A HACK for compilers that don't think critically about cross-
  # compilation. Please do *not* use unless you really know what you are doing.
  __targetPackages

, # The standard environment to use for building packages.
  stdenv

, # This is used because stdenv replacement and the stdenvCross do benefit from
  # the overridden configuration provided by the user, as opposed to the normal
  # bootstrapping stdenvs.
  allowCustomOverrides

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for files
  # in standard system directories (/usr/include, etc.)
  noSysDirs ? stdenv.buildPlatform.system != "x86_64-freebsd"
           && stdenv.buildPlatform.system != "i686-freebsd"
           && stdenv.buildPlatform.system != "x86_64-solaris"
           && stdenv.buildPlatform.system != "x86_64-kfreebsd-gnu"

, # The configuration attribute set
  config

, # A list of overlays (Additional `self: super: { .. }` customization
  # functions) to be fixed together in the produced package set
  overlays
}:

let
  stdenvAdapters = self: super:
    let res = import ../stdenv/adapters.nix self; in res // {
      stdenvAdapters = res;
    };

  trivialBuilders = self: super:
    import ../build-support/trivial-builders.nix {
      inherit lib; inherit (self) stdenv stdenvNoCC; inherit (self.xorg) lndir;
    };

  stdenvBootstappingAndPlatforms = self: super: {
    buildPackages = (if buildPackages == null then self else buildPackages)
      // { recurseForDerivations = false; };
    __targetPackages = (if __targetPackages == null then self else __targetPackages)
      // { recurseForDerivations = false; };
    inherit stdenv;
  };

  # The old identifiers for cross-compiling. These should eventually be removed,
  # and the packages that rely on them refactored accordingly.
  platformCompat = self: super: let
    inherit (super.stdenv) buildPlatform hostPlatform targetPlatform;
  in {
    stdenv = super.stdenv // {
      inherit (super.stdenv.buildPlatform) platform;
    };
    inherit buildPlatform hostPlatform targetPlatform;
    inherit (buildPlatform) system platform;
  };

  splice = self: super: import ./splice.nix lib self (buildPackages != null);

  allPackages = self: super:
    let res = import ./all-packages.nix
      { inherit lib nixpkgsFun noSysDirs config; }
      res self;
    in res;

  aliases = self: super: import ./aliases.nix super;

  # stdenvOverrides is used to avoid having multiple of versions
  # of certain dependencies that were used in bootstrapping the
  # standard environment.
  stdenvOverrides = self: super:
    (super.stdenv.overrides or (_: _: {})) self super;

  # Allow packages to be overridden globally via the `packageOverrides'
  # configuration option, which must be a function that takes `pkgs'
  # as an argument and returns a set of new or overridden packages.
  # The `packageOverrides' function is called with the *original*
  # (un-overridden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  configOverrides = self: super:
    lib.optionalAttrs allowCustomOverrides
      ((config.packageOverrides or (super: {})) super);

  # The complete chain of package set builders, applied from top to bottom
  toFix = lib.foldl' (lib.flip lib.extends) (self: {}) ([
    stdenvBootstappingAndPlatforms
    platformCompat
    stdenvAdapters
    trivialBuilders
    splice
    allPackages
    aliases
    stdenvOverrides
    configOverrides
  ] ++ overlays);

in
  # Return the complete set of packages.
  lib.fix toFix
