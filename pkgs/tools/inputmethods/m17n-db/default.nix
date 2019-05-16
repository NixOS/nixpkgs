{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "m17n-db-1.8.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/${name}.tar.gz";
    sha256 = "0vfw7z9i2s9np6nmx1d4dlsywm044rkaqarn7akffmb6bf1j6zv5";
  };

  buildInputs = [ gettext ];

  configureFlags = stdenv.lib.optional (stdenv ? glibc)
    "--with-charmaps=${stdenv.glibc.out}/share/i18n/charmaps"
  ;

  meta = {
    homepage = https://www.nongnu.org/m17n/;
    description = "Multilingual text processing library (database)";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
  };
}
