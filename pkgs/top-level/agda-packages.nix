{ pkgs, lib, callPackage, newScope, Agda }:

let
  cubical = (import ../build-support/agda/package-index.nix { inherit pkgs; }).cubical;
  mkAgdaPackages = Agda: lib.makeScope newScope (mkAgdaPackages' Agda);
  mkAgdaPackages' = Agda: self: let
    callPackage = self.callPackage;
    inherit (callPackage ../build-support/agda {
      inherit Agda self;
      inherit (pkgs.haskellPackages) ghcWithPackages;
    }) withPackages mkDerivation;
  in {
    inherit mkDerivation;

    agda = withPackages [] // { inherit withPackages; };

    standard-library = callPackage ../development/libraries/agda/standard-library {
      inherit (pkgs.haskellPackages) ghcWithPackages;
    };

    iowa-stdlib = callPackage ../development/libraries/agda/iowa-stdlib { };

    agda-prelude = callPackage ../development/libraries/agda/agda-prelude { };

    agda-categories = callPackage ../development/libraries/agda/agda-categories { };

    cubical = callPackage cubical {};
  };
in mkAgdaPackages Agda
