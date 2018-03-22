{ stdenv, fetchurl, pkgconfig, fuse, libarchive }:

let
  name = "archivemount-0.8.9";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cybernoia.de/software/archivemount/${name}.tar.gz";
    sha256 = "0v4si1ri6lhnq9q87gkx7fsh6lv6xz4bynknwndqncpvfp5cy1jg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse libarchive ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
