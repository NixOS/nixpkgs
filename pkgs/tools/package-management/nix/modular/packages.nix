{
  lib,
  splicePackages,
  nixDependencies,
  pkgs,
  maintainers,
  otherSplices,
  version,
  src,
}:
let
  officialRelease = true;

  # A new scope, so that we can use `callPackage` to inject our own interdependencies
  # without "polluting" the top level "`pkgs`" attrset.
  # This also has the benefit of providing us with a distinct set of packages
  # we can iterate over.
  nixComponents =
    lib.makeScopeWithSplicing'
      {
        inherit splicePackages;
        inherit (nixDependencies) newScope;
      }
      {
        inherit otherSplices;
        f =
          scope:
          import ./packaging/components.nix {
            inherit
              lib
              maintainers
              officialRelease
              pkgs
              src
              version
              ;
          } scope
          // {
            boehmgc = nixDependencies.boehmgc-no-coroutine-patch;
            libgit2 = nixDependencies.libgit2-thin-packfile;
          };
      };

in
nixComponents.overrideSource src
