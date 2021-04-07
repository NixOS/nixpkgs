{ pkgs, callPackage, CoreServices }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-03-22";
    version = "unstable-${rev}";
    sha256 = "sha256-Q8yr5x4+R9UCk5kw/nJgBtGVBeZTDwyuwpyNJUKSPzA=";
    cargoSha256 = "sha256-cJ5KPNrX1H4IfHENDGyU2rgxl5TTqvoeXk7558oqwuA=";

    inherit CoreServices;
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
