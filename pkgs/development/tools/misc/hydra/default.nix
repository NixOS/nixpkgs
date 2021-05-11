{ fetchFromGitHub, nixStable, callPackage, nixFlakes, nixosTests }:

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
    version = "2021-05-03";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "886e6f85e45a1f757e9b77d2a9e4539fbde29468";
      sha256 = "t7Qb57Xjc0Ou+VDGC1N5u9AmeODW6MVOwKSrYRJq5f0=";
    };
    nix = nixFlakes;

    tests = {
      db-migration = nixosTests.hydra-db-migration.mig;
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
