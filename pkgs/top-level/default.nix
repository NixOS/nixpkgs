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

  # Allow packages to be overriden globally via the `packageOverrides'
  # configuration option, which must be a function that takes `pkgs'
  # as an argument and returns a set of new or overriden packages.
  # The `packageOverrides' function is called with the *original*
  # (un-overriden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  pkgs = pkgsWithOverrides (self: config.packageOverrides or (super: {}));

  # stdenvOverrides is used to avoid circular dependencies for building the
  # standard build environment. This mechanism use the override mechanism to
  # implement some staged compilation of the stdenv.
  #
  # We don't want stdenv overrides in the case of cross-building, or
  # otherwise the basic overrided packages will not be built with the
  # crossStdenv adapter.
  stdenvOverrides = pkgs:
    lib.optionalAttrs (crossSystem == null && pkgs.stdenv ? overrides)
      (pkgs.stdenv.overrides pkgs);

  # Return the complete set of packages, after applying the overrides
  # returned by the `overrider' function (see above).  Warning: this
  # function is very expensive!
  pkgsWithOverrides = overrider:
    let
      stdenvAdapters =
        import ../stdenv/adapters.nix pkgs;

      trivialBuilders =
        (import ../build-support/trivial-builders.nix { inherit lib; inherit (pkgs) stdenv; inherit (pkgs.xorg) lndir; });

      stdenvDefault = (import ./stdenv.nix topLevelArguments) {} pkgs;

      selfArgs = topLevelArguments // { inherit pkgsWithOverrides stdenvAdapters; };
      self = (import ./all-packages.nix selfArgs) self pkgs;

      aliases = import ./aliases.nix self;

      pkgs_2 = stdenvAdapters;
      pkgs_3 = pkgs_2 // trivialBuilders;
      pkgs_4 = pkgs_3 // stdenvDefault;
      pkgs_5 = pkgs_4 // self;
      pkgs_6 = pkgs_5 // aliases;

      pkgs_7 = pkgs_6 // overrider pkgs pkgs_6;

      # The overriden, final packages.
      pkgs =   pkgs_7 // stdenvOverrides pkgs_6;
    in pkgs;

in
  pkgs
