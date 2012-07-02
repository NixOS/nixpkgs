{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "smartmontools-5.43";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "d845187d1500b87ef8d2c43772bd0218a59114fe58474a903c56777c9175351e";
  };

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = "http://smartmontools.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
