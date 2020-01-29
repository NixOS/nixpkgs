{ stdenv, fetchurl, gtk2, readline, ncurses, gettext, openssl, pkgconfig }:

stdenv.mkDerivation {
  name = "gftp-2.0.19";

  src = fetchurl {
    url = https://www.gftp.org/gftp-2.0.19.tar.bz2;
    sha256 = "1z8b26n23k0sjbxgrix646b06cnpndpq7cbcj0ilsvvdx5ms81jk";
  };

  postPatch = ''
    sed -i -e '/<stropts.h>/d' lib/pty.c
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 readline ncurses gettext openssl ];

  meta = {
    description = "GTK-based FTP client";
    homepage = http://www.gftp.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
