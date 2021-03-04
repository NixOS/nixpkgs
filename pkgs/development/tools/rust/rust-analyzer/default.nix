{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-02-22";
    version = "unstable-${rev}";
    sha256 = "sha256-QiVSwpTTOqR2WEm0nXyLLavlF2DnY9GY93HtpgHt2uI=";
    cargoSha256 = "sha256-934ApOv/PJzkLc/LChckb/ZXKrh4kU556Bo/Zck+q8g=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
