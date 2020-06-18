{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-06-15";
    version = "unstable-${rev}";
    sha256 = "1qwkhzhgw6sap6vf5ilzr96a88r3snfrf3fcfkzw3n67j7lvsprf";
    cargoSha256 = "0gcgfgrrjxzcgdci709dvx3904sbqx03w4pkbj89kk44j65cdzsy";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
