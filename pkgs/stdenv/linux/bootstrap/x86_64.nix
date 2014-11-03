# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/x86_64/73b75f6157db79fc899154a497823e82e409e76d/bootstrap-tools.tar.xz;
    sha256 = "e29d47a5dc9f1ff10c3fbaacbd03a3cca0c784299df09fcdd9e25797ec6414ad";
  };
}
