{
  busybox = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/8d66a51a872af1ab58edc68a2ebddcc79958b563/busybox;
    sha256 = "9278001d11bb0359d0cc1b30bd5c9823f0b9c65db127d6dfcc1f6bbc000d15a0";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/8d66a51a872af1ab58edc68a2ebddcc79958b563/bootstrap-tools.tar.xz;
    sha256 = "6bc27ce9b08adcca0298f5fe80fe67f5bbb2dffdd1d8666fd44cb76ace198a25";
  };
}
