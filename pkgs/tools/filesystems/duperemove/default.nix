{ lib, stdenv, fetchurl, libgcrypt, pkgconfig, glib, linuxHeaders }:

stdenv.mkDerivation rec {
  name = "duperemove-${version}";
  version = "0.09.beta2";

  src = fetchurl {
    url = "https://github.com/markfasheh/duperemove/archive/v${version}.tar.gz";
    sha256 = "0rn7lf9rjf4ypgfwms2y7b459rri4rfn809h6wx8xl9nbm5niil4";
  };

  buildInputs = [ libgcrypt pkgconfig glib linuxHeaders ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = https://github.com/markfasheh/duperemove;
    license = lib.licenses.gpl2;

    maintainers = [ lib.maintainers.bluescreen303 ];
    platforms = lib.platforms.all;
  };
}
