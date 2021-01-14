{ fetchFromGitHub, nixStable, callPackage, nixFlakes, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-02-19";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "ebf1cd22efdb72d6a78af774b04b852d05dbc153";
      sha256 = "sha256-qrFql1OitnKXx7JMh/Ers53qZij6uI1TsOdfFEuLxZY=";
    };
    nix = nixFlakes;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
