{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "wireless-tools-${version}";
  version = "30";

  src = fetchurl {
    url = "http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.${version}.pre9.tar.gz";
    sha256 = "0qscyd44jmhs4k32ggp107hlym1pcyjzihiai48xs7xzib4wbndb";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out CC=$CC LDCONFIG=: AR=$AR RANLIB=$RANLIB)
  ";

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
