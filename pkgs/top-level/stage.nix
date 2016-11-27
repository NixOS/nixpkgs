/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */


{ # The system (e.g., `i686-linux') for which to build the packages.
  system

, # The standard environment to use.  Only used for bootstrapping.  If
  # null, the default standard environment is used.
  bootStdenv ? null

, # This is used because stdenv replacement and the stdenvCross do benefit from
  # the overridden configuration provided by the user, as opposed to the normal
  # bootstrapping stdenvs.
  allowCustomOverrides ? (bootStdenv == null)

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for
  # files in standard system directories (/usr/include, etc.)
  noSysDirs ? (system != "x86_64-freebsd" && system != "i686-freebsd"
               && system != "x86_64-solaris"
               && system != "x86_64-kfreebsd-gnu")

, # The configuration attribute set
  config

, crossSystem ? null
, platform
, lib
, nixpkgsFun
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

  stdenvDefault = self: super:
    import ./stdenv.nix {
      inherit system bootStdenv crossSystem config platform lib nixpkgsFun;
    };

  allPackages = self: super:
    let res = import ./all-packages.nix
      { inherit system noSysDirs config crossSystem platform lib nixpkgsFun; }
      res self;
    in res;

  aliases = self: super: import ./aliases.nix super;

  # stdenvOverrides is used to avoid circular dependencies for building
  # the standard build environment. This mechanism uses the override
  # mechanism to implement some staged compilation of the stdenv.
  #
  # We don't want stdenv overrides in the case of cross-building, or
  # otherwise the basic overridden packages will not be built with the
  # crossStdenv adapter.
  stdenvOverrides = self: super:
    lib.optionalAttrs (crossSystem == null && super.stdenv ? overrides)
      (super.stdenv.overrides super);

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
  toFix = lib.foldl' (lib.flip lib.extends) (self: {}) [
    stdenvAdapters
    trivialBuilders
    stdenvDefault
    allPackages
    aliases
    stdenvOverrides
    configOverrides
  ];

  # Use `overridePackages` to easily override this package set.
  # Warning: this function is very expensive and must not be used
  # from within the nixpkgs repository.
  #
  # Example:
  #  pkgs.overridePackages (self: super: {
  #    foo = super.foo.override { ... };
  #  }
  #
  # The result is `pkgs' where all the derivations depending on `foo'
  # will use the new version.

  # Return the complete set of packages. Warning: this function is very
  # expensive!
in lib.makeExtensibleWithCustomName "overridePackages" toFix
