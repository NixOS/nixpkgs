{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "m17n-db-1.7.0";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/m17n/${name}.tar.gz";
    sha256 = "1w08hnsbknrcjlzp42c99bgwc9hzsnf5m4apdv0dacql2s09zfm2";
  };

  buildInputs = [ gettext ];

  configureFlags = stdenv.lib.optional (stdenv ? glibc)
    "--with-charmaps=${stdenv.glibc.out}/share/i18n/charmaps"
  ;

  meta = {
    homepage = http://www.nongnu.org/m17n/;
    description = "Multilingual text processing library (database)";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
  };
}
