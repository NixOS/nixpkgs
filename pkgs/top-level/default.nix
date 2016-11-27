/* This function composes the Nix Packages collection. It:

     1. Applies the final stage to the given `config` if it is a function

     2. Infers an appropriate `platform` based on the `system` if none is
        provided

     3. Defaults to no non-standard config and no cross-compilation target

     4. Uses the above to infer the default standard environment (stdenv) if
        none is provided

     5. Builds the final stage --- a fully booted package set with the chosen
        stdenv

   Use `impure.nix` to also infer the `system` based on the one on which
   evaluation is taking place, and the configuration from environment variables
   or dot-files. */

{ # The system (e.g., `i686-linux') for which to build the packages.
  system

, # Allow a configuration attribute set to be passed in as an argument.
  config ? {}

, crossSystem ? null
, platform ? null
} @ args:

let # Rename the function arguments
  configExpr = config;
  platform_ = platform;

in let
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

  # Partially apply some args for building bootstraping stage pkgs sets
  allPackages = newArgs: import ./stage.nix ({
    inherit lib nixpkgsFun config;
  } // newArgs);

  stdenv = import ../stdenv {
    inherit lib allPackages system platform crossSystem config;
  };

  pkgs = allPackages { inherit system stdenv config crossSystem platform; };

in pkgs
