{ lib, stdenv, fetchurl, gettext, gawk, bash }:

stdenv.mkDerivation rec {
  pname = "m17n-db";
  version = "1.8.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-db-${version}.tar.gz";
    sha256 = "0vfw7z9i2s9np6nmx1d4dlsywm044rkaqarn7akffmb6bf1j6zv5";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [ gettext gawk bash ];

  strictDeps = true;

  configureFlags = [ "--with-charmaps=${stdenv.cc.libc}/share/i18n/charmaps" ]
  ;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (database)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
