{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-02-08";
    version = "unstable-${rev}";
    sha256 = "sha256-Idaaw6d0lvBUyZxpHKQ94aMtgM0zb0P8QRh+3pctX4k=";
    cargoSha256 = "sha256-gV2Ddz6EnYgBYoRLAfhtymnKvA1jNLaypWwraiXa6u4=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
