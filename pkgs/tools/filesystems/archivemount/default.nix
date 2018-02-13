{ stdenv, fetchurl, pkgconfig, fuse, libarchive }:

let
  name = "archivemount-0.8.7";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cybernoia.de/software/archivemount/${name}.tar.gz";
    sha256 = "1diiw6pnlnrnikn6l5ld92dx59lhrxjlqms8885vwbynsjl5q127";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse libarchive ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
