{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-07-27";
    version = "unstable-${rev}";
    sha256 = "0wh4m4ljfyr3bs2svh93zrgvpm00j7vchncch90mk6viiryr2733";
    cargoSha256 = "0gk98rxpqhxxrlx0dxk0b6p055zs20ipx8aiyy75rfpk0lf57cp5";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
