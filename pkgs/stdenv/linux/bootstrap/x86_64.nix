# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/x86_64/ac8e5cd145fa5f22bab1b01d8b4db4d26d22e65c/bootstrap-tools.tar.xz;
    sha256 = "01485vvwxb7fsx8c8il5hip0bhh4xy2gg76sj4zc98gl4v1jbfq9";
  };
}
