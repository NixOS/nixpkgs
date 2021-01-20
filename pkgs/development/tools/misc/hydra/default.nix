{ fetchFromGitHub, nixStable, callPackage, nixFlakes, nixosTests }:

{
  hydra-unstable = callPackage ./common.nix {
    version = "2020-10-20";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "79d34ed7c93af2daf32cf44ee0e3e0768f13f97c";
      sha256 = "1lql899430137l6ghnhyz0ivkayy83fdr087ck2wq3gf1jv8pccj";
    };
    patches = [
      ./hydra-nix-receiveContents.patch
    ];
    nix = nixFlakes;

    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  };
}
