{ fetchFromGitHub, nixStable, callPackage, nixFlakes, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-03-29";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "9bb04ed97af047968196bad1728f927f7a6d905f";
      sha256 = "sha256-gN/zNI2hGDMnYUjeGnU7SAuXP4KCmNqG+AYOVfINaQE=";
    };
    nix = nixFlakes;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
