{
  busybox = import <nix/fetchurl.nix> {
    url = "https://wdtz.org/files/gywxhjgl70sxippa0pxs0vj5qcgz1wi8-stdenv-bootstrap-tools/on-server/busybox";
    sha256 = "0779c2wn00467h76xpqil678gfi1y2p57c7zq2d917jsv2qj5009";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://wdtz.org/files/gywxhjgl70sxippa0pxs0vj5qcgz1wi8-stdenv-bootstrap-tools/on-server/bootstrap-tools.tar.xz";
    sha256 = "1dwiqw4xvnm0b5fdgl89lz2qq45f6s9icwxn6n6ams71xw0dbqyi";
  };
}
