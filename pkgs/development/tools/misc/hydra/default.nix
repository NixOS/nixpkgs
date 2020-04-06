{ fetchFromGitHub, nixStable, nixUnstable, callPackage, nixFlakes }:

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

  # Hydra from latest master (or flakes) branch. Contains breaking changes,
  # so when having an older version, `pkgs.hydra-migration` should be deployed first.

  hydra-unstable = callPackage ./common.nix {
    version = "2020-03-24";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "12cc46cdb36321acd4c982429a86eb0f8f3cc969";
      sha256 = "10ipxzdxr47c8w5jg69mbax2ykc7lb5fs9bbdd3iai9wzyfz17ln";
    };
    nix = nixUnstable;
  };

  hydra-flakes = callPackage ./common.nix {
    version = "2020-03-27";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "a7540b141d085a7e78c21fda8e8c05907c659b34";
      sha256 = "08fs7593w5zs8vh4c66gvrxk6s840pp6hj8nwf51wsa27kg5a943";
    };
    nix = nixFlakes;
  };
}
