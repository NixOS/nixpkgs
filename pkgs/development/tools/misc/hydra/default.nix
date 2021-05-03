{ fetchFromGitHub, nixStable, callPackage, nixFlakes, nixosTests }:

{
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
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
