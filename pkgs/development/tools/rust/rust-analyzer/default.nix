{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-08-10";
    version = "unstable-${rev}";
    sha256 = "0hf9gpvgq7whrc5gnfhc0wjqddp3xpi3azvdccb4yql2pcznz3rh";
    cargoSha256 = "1bwch08y2av7aj2l5pvhdxdq24c8favxppz5zcd88rx4brlwn2bq";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
