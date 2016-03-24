/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */


{ # The system (e.g., `i686-linux') for which to build the packages.
  system ? builtins.currentSystem

, # The standard environment to use.  Only used for bootstrapping.  If
  # null, the default standard environment is used.
  bootStdenv ? null

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for
  # files in standard system directories (/usr/include, etc.)
  noSysDirs ? (system != "x86_64-freebsd" && system != "i686-freebsd"
               && system != "x86_64-solaris"
               && system != "x86_64-kfreebsd-gnu")

  # More flags for the bootstrapping of stdenv.
, gccWithCC ? true
, gccWithProfiling ? true

, # Allow a configuration attribute set to be passed in as an
  # argument.  Otherwise, it's read from $NIXPKGS_CONFIG or
  # ~/.nixpkgs/config.nix.
  config ? null

, crossSystem ? null
, platform ? null

  # List of paths that are used to build the base channel, which is used as
  # a reference for security updates.
, defaultPackages ? {
    adapters = import ../stdenv/adapters.nix;
    builders = import ../build-support/trivial-builders.nix;
    stdenv = import ./stdenv.nix;
    all = import ./all-packages.nix;
    aliases = import ./aliases.nix;
  }

  # Additional list of packages, similar to defaultPackages, which is used
  # to apply security fixes to a few packages which would be compiled, and
  # to patch any of their dependencies, to have a fast turn-around.
, quickfixPackages ? null
}:


let config_ = config; platform_ = platform; in # rename the function arguments

let

  lib = import ../../lib;

  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  # for NIXOS (nixos-rebuild): use nixpkgs.config option
  config =
    let
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      configExpr =
        if config_ != null then config_
        else if configFile != "" && pathExists configFile then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2 then import (toPath configFile2)
        else {};

    in
      # allow both:
      # { /* the config */ } and
      # { pkgs, ... } : { /* the config */ }
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
    inherit system bootStdenv noSysDirs gccWithCC gccWithProfiling config
      crossSystem platform lib;
  };

  # Allow packages to be overridden globally via the `packageOverrides'
  # configuration option, which must be a function that takes `pkgs'
  # as an argument and returns a set of new or overridden packages.
  # The `packageOverrides' function is called with the *original*
  # (un-overridden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  pkgs = lib.fix' (unfixPkgsWithPackages defaultPackages);

  unfixPkgsWithPackages =
    unfixPkgsWithOverridesWithPackages (self: config.packageOverrides or (super: {}));

  # Return the complete set of packages, after applying the overrides
  # returned by the `overrider' function (see above).  Warning: this
  # function is very expensive!
  unfixPkgsWithOverridesWithPackages = overrider: packages:
    let
      stdenvAdapters = self: super:
        let res = packages.adapters self; in res // {
          stdenvAdapters = res;
        };

      trivialBuilders = self: super:
        (packages.builders {
          inherit lib; inherit (self) stdenv; inherit (self.xorg) lndir;
        });

      stdenvDefault = self: super: (packages.stdenv topLevelArguments) {} pkgs;

      allPackagesArgs = topLevelArguments // {
        pkgsWithOverrides = overrider:
          lib.fix' (unfixPkgsWithOverridesWithPackages overrider defaultPackages);
      };
      allPackages = self: super:
        let res = packages.all allPackagesArgs res self;
        in res;

      aliases = self: super: packages.aliases super;

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

      customOverrides = self: super:
        lib.optionalAttrs (bootStdenv == null) (overrider self super);
    in
      lib.extends customOverrides (
        lib.extends stdenvOverrides (
          lib.extends aliases (
            lib.extends allPackages (
              lib.extends stdenvDefault (
                lib.extends trivialBuilders (
                  lib.extends stdenvAdapters (
                    self: {})))))));

  # Apply ABI compatible fixes:
  #  1. This will cause the recompilation of packages which have a different
  #     derivation in quickfix, than what they have in the default packages.
  #  2. This will patch any of the dependencies to substitute the hash of
  #     the default packages by the corresponding hash of the quickfix
  #     packages which got recompiled.
  #
  # If there is no quickfix to apply, or if we are bootstrapping the
  # compilation environment, then there is no need for making any patches.
  maybeApplyAbiCompatiblePatches = pkgs:
    if bootStdenv == null && quickfixPackages != null then
      throw "NYI"
    else
      pkgs;

in
  maybeApplyAbiCompatiblePatches pkgs
