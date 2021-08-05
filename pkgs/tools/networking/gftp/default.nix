{ lib, stdenv, fetchurl, gtk2, readline, ncurses, gettext, openssl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "gftp";
  version = "2.0.19";

  src = fetchurl {
    url = "https://www.gftp.org/gftp-${version}.tar.bz2";
    sha256 = "1z8b26n23k0sjbxgrix646b06cnpndpq7cbcj0ilsvvdx5ms81jk";
  };

  postPatch = ''
    sed -i -e '/<stropts.h>/d' lib/pty.c
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 readline ncurses gettext openssl ];

  meta = {
    description = "GTK-based FTP client";
    homepage = "http://www.gftp.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
