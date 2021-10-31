{ fetchFromGitHub, nixStable, callPackage, nixUnstable, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-10-27";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "9ae676072c4b4516503b8e661a1261e5a9b4dc95";
      sha256 = "sha256-kw6ogxYmSfB26lLpBF/hEP7uJbrjuWgw8L2OjrD5JiM=";
    };
    nix = nixUnstable;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
