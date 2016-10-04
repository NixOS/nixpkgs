{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ised-${version}";
  version = "2.7.1";
  src = fetchurl {
    url = "mirror://sourceforge/project/ised/${name}.tar.bz2";
    sha256 = "0fhha61whkkqranqdxg792g0f5kgp5m3m6z1iqcvjh2c34rczbmb";
  };

  meta = {
    description = "A numeric sequence editor";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
