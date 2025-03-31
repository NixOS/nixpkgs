{
  lib,
  fetchFromGitHub,
  splicePackages,
  nixDependencies,
  pkgs,
  maintainers,
  otherSplices,
  version,
}:
let
  officialRelease = true;
  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

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
        f = import ./packaging/components.nix {
          inherit
            lib
            maintainers
            officialRelease
            pkgs
            src
            version
            ;
        };
      };

in
nixComponents.overrideSource src
