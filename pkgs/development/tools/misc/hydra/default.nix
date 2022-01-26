{ fetchFromGitHub, callPackage, nixVersions, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-08-11";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "9bce425c3304173548d8e822029644bb51d35263";
      sha256 = "sha256-tGzwKNW/odtAYcazWA9bPVSmVXMGKfXsqCA1UYaaxmU=";
    };
    nix = nixVersions.unstable;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
