{ fetchFromGitHub, nixStable, callPackage, nixFlakes, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-03-10";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "930f05c38eeac63ad6c3e3250de2667e2df2e96e";
      sha256 = "06s2lg119p96i1j4rdbg3z097n25bgvq8ljdn4vcwcw3yz0lnswm";
    };
    nix = nixFlakes;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
