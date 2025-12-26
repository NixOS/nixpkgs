{
  pkgs,
  config,
  lib,
  newScope,
  Agda,
}:

let
  mkAgdaPackages = Agda: lib.makeScope newScope (mkAgdaPackages' Agda);
  mkAgdaPackages' =
    Agda: self:
    let
      inherit (self) callPackage;
      inherit
        (callPackage ../build-support/agda {
          inherit Agda self;
          inherit (pkgs.haskellPackages) ghcWithPackages;
        })
        withPackages
        mkLibraryFile
        mkDerivation
        ;
    in
    {
      inherit mkLibraryFile mkDerivation;

      lib = lib.extend (final: prev: import ../build-support/agda/lib.nix { lib = prev; });

      agda = withPackages [ ];

      standard-library = callPackage ../development/libraries/agda/standard-library { };

      iowa-stdlib = callPackage ../development/libraries/agda/iowa-stdlib { };

      agda-prelude = callPackage ../development/libraries/agda/agda-prelude { };

      agda-categories = callPackage ../development/libraries/agda/agda-categories { };

      agda2hs-base = callPackage ../development/libraries/agda/agda2hs-base { };

      cubical = callPackage ../development/libraries/agda/cubical { };

      cubical-mini = callPackage ../development/libraries/agda/cubical-mini { };

      functional-linear-algebra = callPackage ../development/libraries/agda/functional-linear-algebra { };

      agdarsec = callPackage ../development/libraries/agda/agdarsec { };

      _1lab = callPackage ../development/libraries/agda/1lab { };

      generics = callPackage ../development/libraries/agda/generics { };
    }
    // lib.optionalAttrs config.allowAliases {
      generic = throw "agdaPackages.generic has been removed because it is unmaintained upstream and has been marked as broken since 2021. Consider using agdaPackages.generics instead."; # Added 2025-10-11
    };
in
mkAgdaPackages Agda
