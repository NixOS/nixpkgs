{ stdenv, fetchurl, pkgconfig, fuse, libarchive }:

let
  name = "archivemount-0.6.1";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cybernoia.de/software/archivemount/${name}.tar.gz";
    sha256 = "9235d6377a70a7c25aa288dab6b0e8ef906d1d219d43e5b8fcdb8cf3ace98e01";
  };

  buildInputs = [ pkgconfig fuse libarchive ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    license = "GPL2";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
