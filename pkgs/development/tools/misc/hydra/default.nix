{ lib, fetchFromGitHub, callPackage, nixVersions, nixosTests, fetchpatch }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2022-02-07";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "517dce285a851efd732affc084c7083aed2e98cd";
      sha256 = "sha256-abWhd/VLNse3Gz7gcVbFANJLAhHV4nbOKjhVDmq/Zmg=";
    };
    patches = [
      ./eval.patch
      ./missing-std-string.patch
      (fetchpatch {
        url = "https://github.com/NixOS/hydra/commit/5ae26aa7604f714dcc73edcb74fe71ddc8957f6c.patch";
        sha256 = "sha256-wkbWo8SFbT3qwVxwkKQWpQT5Jgb1Bb51yiLTlFdDN/I=";
      })
    ];
    nix = nixVersions.nix_2_6;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
