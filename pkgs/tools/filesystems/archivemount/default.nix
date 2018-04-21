{ stdenv, fetchurl, pkgconfig, fuse, libarchive }:

let
  name = "archivemount-0.8.12";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cybernoia.de/software/archivemount/${name}.tar.gz";
    sha256 = "12fb8fcmd1zwvfgzx4pay47md5cr2kgxcgq82cm6skmq75alfzi4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse libarchive ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
