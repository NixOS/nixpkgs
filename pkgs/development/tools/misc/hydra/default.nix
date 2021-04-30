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
    version = "2021-04-29";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "6047b1dd04d44acff9343b6b971ab609b73099d5";
      sha256 = "sha256-E7JOHhSd4gIzE6FvSZVMxZE9WagbBkrfZVoibkanaYE=";
    };
    nix = nixFlakes;

    tests = {
      db-migration = nixosTests.hydra-db-migration.mig;
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
