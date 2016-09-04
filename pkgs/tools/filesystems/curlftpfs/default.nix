{stdenv, fetchurl, fuse, curl, pkgconfig, glib, zlib}:

stdenv.mkDerivation {
  name = "curlftpfs-0.9.2";
  src = fetchurl {
    url = mirror://sourceforge/curlftpfs/curlftpfs-0.9.2.tar.gz;
    sha256 = "0n397hmv21jsr1j7zx3m21i7ryscdhkdsyqpvvns12q7qwwlgd2f";
  };
  buildInputs = [fuse curl pkgconfig glib zlib];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
