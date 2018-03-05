{
  busybox = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/6bh4giyw5rf8mc28621rxipw8d6w6w8d-stdenv-bootstrap-tools/on-server/busybox;
    sha256 = "0779c2wn00467h76xpqil678gfi1y2p57c7zq2d917jsv2qj5009";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/6bh4giyw5rf8mc28621rxipw8d6w6w8d-stdenv-bootstrap-tools/on-server/bootstrap-tools.tar.xz;
    sha256 = "197h8gjw51q3i25myapzgqba2l4h2skzwi3q1iry26mzjjmbcvys";
  };
}
