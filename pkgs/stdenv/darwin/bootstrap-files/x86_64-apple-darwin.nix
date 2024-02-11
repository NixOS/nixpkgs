let
  fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/c253216595572930316f2be737dc288a1da22558/${file}";
    inherit sha256 executable;
  }; in
{
  sh = fetch { file = "sh"; sha256 = "sha256-igMAVEfumFv/LUNTGfNi2nSehgTNIP4Sg+f3L7u6SMA="; };
  bzip2 = fetch { file = "bzip2"; sha256 = "sha256-K3rhkJZipudT1Jgh+l41Y/fNsMkrPtiAsNRDha/lpZI="; };
  mkdir = fetch { file = "mkdir"; sha256 = "sha256-VddFELwLDJGNADKB1fWwWPBtIAlEUgJv2hXRmC4NEeM="; };
  cpio = fetch { file = "cpio"; sha256 = "sha256-SWkwvLaFyV44kLKL2nx720SvcL4ej/p2V/bX3uqAGO0="; };
  tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "sha256-kRC/bhCmlD4L7KAvJQgcukk7AinkMz4IwmG1rqlh5tA="; executable = false; };
}
