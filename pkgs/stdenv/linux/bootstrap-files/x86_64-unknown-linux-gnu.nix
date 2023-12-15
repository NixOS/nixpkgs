# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686-unknown-linux-gnu.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/x86_64/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31/bootstrap-tools.tar.xz";
    sha256 = "a5ce9c155ed09397614646c9717fc7cd94b1023d7b76b618d409e4fefd6e9d39";
  };
}
