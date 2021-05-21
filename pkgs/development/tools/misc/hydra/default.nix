{ fetchFromGitHub, nixStable, callPackage, nixUnstable, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-05-03";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "886e6f85e45a1f757e9b77d2a9e4539fbde29468";
      sha256 = "t7Qb57Xjc0Ou+VDGC1N5u9AmeODW6MVOwKSrYRJq5f0=";
    };
    nix = nixUnstable;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
