{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-09-28";
    version = "unstable-${rev}";
    sha256 = "1ynwrkdy78105xbrcynk0qimk90y849hn54sw8q3akdlyfx1kdrs";
    cargoSha256 = "0iy7h3q7dp2nbfzzg7yc8zbkb5npghz8l15d83xd8w8q39i3qff5";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
