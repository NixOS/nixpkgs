{ lib, stdenv, fetchurl, gettext, gawk, bash }:

stdenv.mkDerivation rec {
  pname = "m17n-db";
  version = "1.8.5";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-db-${version}.tar.gz";
    sha256 = "sha256-to//QiwKKGTuVuLEUXOCEzuYG7S6ObU/R4lc2LHApzY=";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [ gettext gawk bash ];

  strictDeps = true;

  configureFlags = [ "--with-charmaps=${stdenv.cc.libc}/share/i18n/charmaps" ]
  ;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (database)";
    changelog = "https://git.savannah.nongnu.org/cgit/m17n/m17n-db.git/plain/NEWS?h=REL-${lib.replaceStrings [ "." ] [ "-" ] version}";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
