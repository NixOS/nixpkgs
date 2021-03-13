{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-03-08";
    version = "unstable-${rev}";
    sha256 = "sha256-PqYU9WiEXfrVQCmbib2NiUtQnwWg863QoHS+Y0WVZw4=";
    cargoSha256 = "sha256-fcsbCjFH+EQ5dxeuS0Q/hYyobA7mMcgCekKmUgDX0ig=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
