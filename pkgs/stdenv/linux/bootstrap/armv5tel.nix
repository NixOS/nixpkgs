let

  fetch = { file, sha256 }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/r18744/${file}";
    inherit sha256;
    executable = true;
  };

in {
  busybox = import <nix/fetchurl.nix> {
    url = file:///home/viric/busybox
    sha256 = "80d6e9839d41cd8d77bf6b50a0ce19e112766ff5653a5520a2dfd0e0707f5da0";
    executable = true;
  };

  bootstrapTools = {
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/r18744/bootstrap-tools.cpio.bz2";
    sha256 = "1rn4n5kilqmv62dfjfcscbsm0w329k3gyb2v9155fsi1sl2cfzcb";
  };
}
