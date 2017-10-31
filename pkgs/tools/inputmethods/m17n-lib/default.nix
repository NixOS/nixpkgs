{stdenv, fetchurl, m17n_db}:
stdenv.mkDerivation rec {
  name = "m17n-lib-1.7.0";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/m17n/${name}.tar.gz";
    sha256 = "10yv730i25g1rpzv6q49m6xn4p8fjm7jdwvik2h70sn8w3hm7f4f";
  };

  buildInputs = [ m17n_db ];

  meta = {
    homepage = http://www.nongnu.org/m17n/;
    description = "Multilingual text processing library (runtime)";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
  };
}
