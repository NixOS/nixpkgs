{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-03-15";
    version = "unstable-${rev}";
    sha256 = "150gydm0mg72bbhgjjks8qc5ldiqyzhai9z4yfh4f1s2bwdfh3yf";
    cargoSha256 = "10l0lk5p11002q59dqa5yrrz6n6s11i7bmr1wnl141bxqvm873q2";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
