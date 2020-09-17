{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-09-21";
    version = "unstable-${rev}";
    sha256 = "1wjm69r1c6s8a4rd91csg7c48bp8jamxsrm5m6rg3bk2gqp8yzz8";
    cargoSha256 = "089w2i6lvpjxkxghkb2mij9sxfxlcc1zv4iq4qmzq8gnc6ddz12d";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
