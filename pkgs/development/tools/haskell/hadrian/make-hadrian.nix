# Hadrian is the build system used to (exclusively) build GHC. It can
# (theoretically) be used starting with GHC 9.4 and is required since 9.6. It is
# developed in the GHC source tree and specific to the GHC version it is released
# with, i.e. Hadrian always needs to be built from the same GHC source tree as
# the GHC we want to build.
#
# This fact makes it impossible to integrate Hadrian into our Haskell package
# sets which are also used to bootstrap GHC, since a package set can bootstrap
# multiple GHC versions (usually two major versions). A bootstrap set would need
# knowledge of the GHC it would eventually bootstrap which would make the logic
# unnecessarily complicated.
#
# Luckily Hadrian is, while annoying to bootstrap, relatively simple. Specifically
# all it requires to build is (relative to the GHC we are trying to build) a
# build->build GHC and build->build Haskell packages. We can get all of this
# from bootPkgs which is already passed to the GHC expression.
#
# The solution is the following: The GHC expression passes its source tree and
# version along with some parameters to this function (./make-hadrian.nix)
# which acts as a common expression builder for all Hadrian version as well as
# related packages that are managed in the GHC source tree. Its main job is to
# expose all possible compile time customization in a common interface and
# take care of all differences between Hadrian versions.
{
  bootPkgs,
  lib,
}:

{
  # GHC source tree and version to build hadrian & friends from.
  # These are passed on to the actual package expressions.
  ghcSrc,
  ghcVersion,
  # Contents of a non-default UserSettings.hs to use when building hadrian, if any.
  # Should be a string or null.
  userSettings ? null,
}:

let
  callPackage' =
    f: args:
    bootPkgs.callPackage f (
      {
        inherit ghcSrc ghcVersion;
      }
      // args
    );

  ghc-platform = callPackage' ./ghc-platform.nix { };
  ghc-toolchain = callPackage' ./ghc-toolchain.nix {
    inherit ghc-platform;
  };
in

callPackage' ./hadrian.nix (
  {
    inherit userSettings;
    # Taking `ghc` as an input may be too confusing
    bootGhcVersion = bootPkgs.ghc.version;
  }
  // lib.optionalAttrs (lib.versionAtLeast ghcVersion "9.9") {
    # Starting with GHC 9.9 development, additional in tree packages are required
    # to build hadrian. (Hackage-released conditional dependencies are handled
    # in ./hadrian.nix without requiring intervention here.)
    inherit ghc-platform ghc-toolchain;
  }
  // lib.optionalAttrs (lib.versionAtLeast ghcVersion "9.11") {
    # See https://gitlab.haskell.org/ghc/ghc/-/commit/145a6477854d4003a07573d5e7ffa0c9a64ae29c
    Cabal = bootPkgs.Cabal_3_14_2_0;
  }
)
