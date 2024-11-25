{ lib, fetchFromGitHub, splicePackages, generateSplicesForMkScope, newScope, pkgs, stdenv,
  libgit2-thin-packfile,
  ... }:
let
  officialRelease = true;
  sourceArgs = builtins.fromJSON (builtins.readFile ./source.json);
  src = fetchFromGitHub sourceArgs;

  version =
    let
      shortRev = lib.strings.substring 0 7 sourceArgs.rev;
      baseVersion = lib.strings.trim (builtins.readFile ./.version);
    in "${baseVersion}pre-${shortRev}";

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
        otherSplices = generateSplicesForMkScope "nixComponents";
        f = import ./packaging/components.nix {
          inherit lib officialRelease src version;
        };
      };

  # The dependencies are in their own scope, so that they don't have to be
  # in Nixpkgs top level `pkgs` or `nixComponents`.
  nixDependencies =
    lib.makeScopeWithSplicing'
      {
        inherit splicePackages;
        inherit newScope; # layered directly on pkgs, unlike nixComponents above
      }
      {
        otherSplices = generateSplicesForMkScope "nixDependencies";
        f = import ./dependencies.nix {
          inherit pkgs;
          inherit stdenv;
          inherit src version;
          inherit libgit2-thin-packfile;
        };
      };
in
  nixComponents.nix-everything
