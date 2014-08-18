{ stdenv, fetchurl, gtk, readline, ncurses, gettext, openssl, pkgconfig }:

stdenv.mkDerivation {
  name = "gftp-2.0.19";

  src = fetchurl {
    url = http://www.gftp.org/gftp-2.0.19.tar.bz2;
    sha256 = "1z8b26n23k0sjbxgrix646b06cnpndpq7cbcj0ilsvvdx5ms81jk";
  };

  buildInputs = [ gtk readline ncurses gettext openssl pkgconfig ];

  meta = { 
    description = "GTK+-based FTP client";
    homepage = http://www.gftp.org;
    license = "GPLv2+";
  };
}
