{
  busybox = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/busybox;
    sha256 = "ef4c1be6c7ae57e4f654efd90ae2d2e204d6769364c46469fa9ff3761195cba1";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/bootstrap-tools.tar.xz;
    sha256 = "cf920d26d94335f5cb46e247455d0e5389765d16a2b8fc233b792a655b5b58aa";
  };
}
