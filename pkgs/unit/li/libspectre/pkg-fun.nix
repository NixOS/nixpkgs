{ fetchurl, lib, stdenv, pkg-config, ghostscript, cairo }:

stdenv.mkDerivation rec {
  pname = "libspectre";
  version = "0.2.7";

  src = fetchurl {
    url = "https://libspectre.freedesktop.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1v63lqc6bhhxwkpa43qmz8phqs8ci4dhzizyy16d3vkb20m846z8";
  };

  patches = [ ./libspectre-0.2.7-gs918.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    # Need `libgs.so'.
    ghostscript cairo /*for tests*/
  ];

  doCheck = true;

  meta = {
    homepage = "http://libspectre.freedesktop.org/";
    description = "PostScript rendering library";

    longDescription = ''
      libspectre is a small library for rendering Postscript
      documents.  It provides a convenient easy to use API for
      handling and rendering Postscript documents.
    '';

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
