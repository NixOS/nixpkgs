{
  busybox = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/busybox;
    sha256 = "ef4c1be6c7ae57e4f654efd90ae2d2e204d6769364c46469fa9ff3761195cba1";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31/bootstrap-tools.tar.xz;
    sha256 = "b9bf20315f8c5c0411679c5326084420b522046057a0850367c67d9514794f1c";
  };
}
