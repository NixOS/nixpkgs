{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "wireless-tools";
  version = "30.pre9";

  src = fetchurl {
    url = "https://hewlettpackard.github.io/wireless-tools/wireless_tools.${version}.tar.gz";
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
    description = "Wireless tools for Linux";
    homepage = "https://hewlettpackard.github.io/wireless-tools/Tools.html";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}
