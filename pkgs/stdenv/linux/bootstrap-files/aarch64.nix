{
  busybox = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/aarch64/bb3ef8a95c9659596b8a34d27881cd30ffea2f9f/busybox;
    sha256 = "12qcml1l67skpjhfjwy7gr10nc86gqcwjmz9ggp7knss8gq8pv7f";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/aarch64/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31/bootstrap-tools.tar.xz;
    sha256 = "d3f1bf2a1495b97f45359d5623bdb1f8eb75db43d3bf2059fc127b210f059358";
  };
}
