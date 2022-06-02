{ pkgs, lib, callPackage, newScope, Agda }:

let
  mkAgdaPackages = Agda: lib.makeScope newScope (mkAgdaPackages' Agda);
  mkAgdaPackages' = Agda: self: let
    callPackage = self.callPackage;
    inherit (callPackage ../build-support/agda {
      inherit Agda self;
      inherit (pkgs.haskellPackages) ghcWithPackages;
    }) withPackages mkDerivation;
  in {
    inherit mkDerivation;

    lib = lib.extend (final: prev: import ../build-support/agda/lib.nix { lib = prev; });

    agda = withPackages [] // {
      inherit withPackages;
      passthru.tests.allPackages = withPackages (lib.filter (pkg: self.lib.isUnbrokenAgdaPackage pkg) (lib.attrValues self));
    };

    standard-library = callPackage ../development/libraries/agda/standard-library {
      inherit (pkgs.haskellPackages) ghcWithPackages;
    };

    iowa-stdlib = callPackage ../development/libraries/agda/iowa-stdlib { };

    agda-prelude = callPackage ../development/libraries/agda/agda-prelude { };

    agda-categories = callPackage ../development/libraries/agda/agda-categories { };

    cubical = callPackage ../development/libraries/agda/cubical { };

    functional-linear-algebra = callPackage
      ../development/libraries/agda/functional-linear-algebra { };

    generic = callPackage ../development/libraries/agda/generic { };

    agdarsec = callPackage ../development/libraries/agda/agdarsec { };
  };
in mkAgdaPackages Agda
