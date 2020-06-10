{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-06-01";
    version = "unstable-${rev}";
    sha256 = "0chm47mrd4hybhvzn4cndq2ck0mj948mm181p1i1j1w0ms7zk1fg";
    cargoSha256 = "0yaz50f7hirlcs8bxc5dh170lch9l1gscwayan71k3pz23wkvlzs";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
