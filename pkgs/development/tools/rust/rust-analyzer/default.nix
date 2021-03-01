{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-03-01";
    version = "unstable-${rev}";
    sha256 = "10x4fk1nxk548cfxrbfvz0kpa2r955d0bcnxxn8k8zmrdqxs3sph";
    cargoSha256 = "02s6qnq61vifx59hnbaalqmfvp8anfik62y6rzy3rwm1l9r85qrz";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
