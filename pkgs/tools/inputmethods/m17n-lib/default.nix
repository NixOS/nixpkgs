{stdenv, fetchurl, m17n_db}:
stdenv.mkDerivation rec {
  name = "m17n-lib-1.8.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/${name}.tar.gz";
    sha256 = "0jp61y09xqj10mclpip48qlfhniw8gwy8b28cbzxy8hq8pkwmfkq";
  };

  buildInputs = [ m17n_db ];

  meta = {
    homepage = https://www.nongnu.org/m17n/;
    description = "Multilingual text processing library (runtime)";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
  };
}
