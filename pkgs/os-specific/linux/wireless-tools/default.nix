{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "wireless-tools";
  version = "30.pre9";

  src = fetchurl {
    url = "http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.${version}.tar.gz";
    sha256 = "0qscyd44jmhs4k32ggp107hlym1pcyjzihiai48xs7xzib4wbndb";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CC:=$(CC)"
    "AR:=$(AR)"
    "RANLIB:=$(RANLIB)"
    "LDCONFIG=:"
  ];

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
}
