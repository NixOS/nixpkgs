{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-08-03";
    version = "unstable-${rev}";
    sha256 = "07xd9gwzjqnjsb5rnxfa9vxc6dmh04mbd1dcwxsz9fv9dcnsx21l";
    cargoSha256 = "0sa8yd3a6y2505w0n9l7d1v03c7dl07zw78fx5r3f4p3lc65n8b4";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
