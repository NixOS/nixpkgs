{ fetchFromGitHub, callPackage, nixVersions, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2021-12-17";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "e1e5fafdff63c1e1595d2edb8c9854710211a0d7";
      sha256 = "sha256-JPkw3heasqX9iWju7BWjKDsyoS+HmLIKM2ibwHq5+Ko=";
    };
    patches = [
      ./eval.patch
      ./missing-std-string.patch
    ];
    nix = nixVersions.nix_2_4;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
