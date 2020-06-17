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
    version = "2020-06-01";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "750e2e618ac6d3df02c57a2cf8758bc66a27c40a";
      sha256 = "1szfzf9kw5cj6yn57gfxrffbdkdf8v3xy9914924blpn5qll31g4";
    };
    nix = nixFlakes;

    patches = [
      (fetchpatch {
        url = "https://github.com/NixOS/hydra/commit/d4822a5f4b57dff26bdbf436723a87dd62bbcf30.patch";
        sha256 = "1n6hyjz1hzvka4wi78d4wg0sg2wanrdmizqy23vmp7pmv8s3gz8w";
      })
    ];

    tests = {
      db-migration = nixosTests.hydra-db-migration.mig;
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
