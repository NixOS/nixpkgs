{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-10-05";
    version = "unstable-${rev}";
    sha256 = "1vj5xwqif2ipzlb8ngpq3ymgqvv65d0700ihq7hx81k0i2m2awa6";
    cargoSha256 = "14n7nk64qq27a7ygqm0bly2bby3bmsav6nvsap3bkbkppyr5gyrg";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
