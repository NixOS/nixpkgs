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

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for
  # files in standard system directories (/usr/include, etc.)
  noSysDirs ? (system != "x86_64-freebsd" && system != "i686-freebsd"
               && system != "x86_64-solaris"
               && system != "x86_64-kfreebsd-gnu")

, # Allow a configuration attribute set to be passed in as an argument.
  config ? {}

, crossSystem ? null
, platform ? null
} @ args:


let configExpr = config; platform_ = platform; in # rename the function arguments

let
  lib = import ../../lib;

  # Allow both:
  # { /* the config */ } and
  # { pkgs, ... } : { /* the config */ }
  config =
    if builtins.isFunction configExpr
    then configExpr { inherit pkgs; }
    else configExpr;

  # Allow setting the platform in the config file. Otherwise, let's use a reasonable default (pc)

  platformAuto = let
      platforms = (import ./platforms.nix);
    in
      if system == "armv6l-linux" then platforms.raspberrypi
      else if system == "armv7l-linux" then platforms.armv7l-hf-multiplatform
      else if system == "armv5tel-linux" then platforms.sheevaplug
      else if system == "mips64el-linux" then platforms.fuloong2f_n32
      else if system == "x86_64-linux" then platforms.pc64
      else if system == "i686-linux" then platforms.pc32
      else platforms.pcBase;

  platform = if platform_ != null then platform_
    else config.platform or platformAuto;

  topLevelArguments = {
    inherit system bootStdenv noSysDirs config crossSystem platform lib nixpkgsFun;
  };

  # A few packages make a new package set to draw their dependencies from.
  # (Currently to get a cross tool chain, or forced-i686 package.) Rather than
  # give `all-packages.nix` all the arguments to this function, even ones that
  # don't concern it, we give it this function to "re-call" nixpkgs, inheriting
  # whatever arguments it doesn't explicitly provide. This way,
  # `all-packages.nix` doesn't know more than it needs too.
  #
  # It's OK that `args` doesn't include the defaults: they'll be
  # deterministically inferred the same way.
  nixpkgsFun = newArgs: import ./. (args // newArgs);

  stdenvAdapters = self: super:
    let res = import ../stdenv/adapters.nix self; in res // {
      stdenvAdapters = res;
    };

  trivialBuilders = self: super:
    (import ../build-support/trivial-builders.nix {
      inherit lib; inherit (self) stdenv stdenvNoCC; inherit (self.xorg) lndir;
    });

  stdenvDefault = self: super: (import ./stdenv.nix topLevelArguments) pkgs;

  allPackages = self: super:
    let res = import ./all-packages.nix topLevelArguments res self;
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
    lib.optionalAttrs (bootStdenv == null)
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
  pkgs = lib.makeExtensibleWithCustomName "overridePackages" toFix;
in pkgs
