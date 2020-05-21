{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-05-18";
    version = "unstable-${rev}";
    sha256 = "1h21jpsn6db8jcgfy2n6sj7vx54kmnc60nc1bfpnc4k8dwr6lc10";
    cargoSha256 = "11qgl7wqd0mdqds8jis8zf55arm8hrlhhddhkbrg9zprwvkycygq";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
