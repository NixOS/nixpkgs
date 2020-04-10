{ fetchFromGitHub, nixStable, callPackage, nixFlakes, fetchpatch }:

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
  };

  # Hydra from latest master branch. Contains breaking changes,
  # so when having an older version, `pkgs.hydra-migration` should be deployed first.

  hydra-unstable = callPackage ./common.nix {
    version = "2020-04-07";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "4cabb37ebdeade1435ad8ebf1913cdd603b9c452";
      sha256 = "1ccy639x6yyrqqqqli7vlqm6pcvcq5dx1w3ckba77rl8pd5h31f7";
    };
    patches = [
      # https://github.com/NixOS/hydra/pull/732
      (fetchpatch {
        url = "https://github.com/NixOS/hydra/commit/2f9d422172235297759f2b224fe0636cad07b6fb.patch";
        sha256 = "0152nsqqc5d85qdygmwrsk88i9y6nk1b639fj2n042pjvr0kpz6k";
      })
    ];
    nix = nixFlakes;
  };
}
