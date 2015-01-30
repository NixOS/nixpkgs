{
  busybox = import <nix/fetchurl.nix> {
    url = "http://192.168.10.4/~viric/tmp/nix/busybox";
    sha256 = "1z5zaa7cs70sndfcpabfhlw4ralzcjv1qhii2vi20vng3ldn2bwm";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/r18744/bootstrap-tools.cpio.bz2";
    sha256 = "1rn4n5kilqmv62dfjfcscbsm0w329k3gyb2v9155fsi1sl2cfzcb";
  };
}
