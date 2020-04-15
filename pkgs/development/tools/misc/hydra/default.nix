{ fetchFromGitHub, nixStable, callPackage, nixFlakes, fetchpatch, nixosTests }:

{
  # Package for phase-1 of the db migration for Hydra.
  # https://github.com/NixOS/hydra/pull/711
  hydra-migration = callPackage ./common.nix {
    version = "2020-02-10";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "add4f610ce6f206fb44702b5a894d877b3a30e3a";
      sha256 = "1d8hdgjx2ys0zmixi2ydmimdq7ml20h1ji4amwawcyw59kssh6l3";
    };
    nix = nixStable;
    migration = true;

    tests = {
      db-migration = nixosTests.hydra-db-migration.mig;
      basic = nixosTests.hydra.hydra-migration;
    };
  };

  # Hydra from latest master branch. Contains breaking changes,
  # so when having an older version, `pkgs.hydra-migration` should be deployed first.

  hydra-unstable = callPackage ./common.nix {
    version = "2020-04-16";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "87837f1d82904bf48e11b5641258b6be2f663c3b";
      sha256 = "1vs3lyfyafsl7wbpmycv7c3n9n2rkrswp65msb6q1iskgpvr96d5";
    };
    nix = nixFlakes;
    tests = {
      db-migration = nixosTests.hydra-db-migration.mig;
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
