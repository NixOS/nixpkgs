{ stdenv, fetchurl, glib, curl, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  name = "megatools-1.9.91";

  src = fetchurl {
    url = "http://megatools.megous.com/builds/${name}.tar.gz";
    sha256 = "0hb83wqsn6mggcmk871hl8cski5x0hxz9dhaka42115s4mdfbl1i";
  };

  buildInputs = [ glib curl pkgconfig fuse ];

  meta = {
    description = "Command line client for Mega.co.nz";
    homepage = http://megatools.megous.com/;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
