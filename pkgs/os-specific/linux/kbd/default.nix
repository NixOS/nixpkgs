{ stdenv, fetchurl, bison, flex, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "kbd-1.15.2";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.gz";
    sha256 = "0ff674y6d3b6ix08b9l2yzv8igns768biyp5y92vip7iz4xv2p2j";
  };

  buildNativeInputs = [ bison flex autoconf automake ];

  # We get a warning in armv5tel-linux and the fuloong2f,
  # so we disable -Werror in it
  patchPhase = if (stdenv.system == "armv5tel-linux" ||
    stdenv.system == "mips64el-linux")
    then ''
      sed -i s/-Werror// src/Makefile.am
    '' else "";

  # Grrr, kbd 1.15.1 doesn't include a configure script.
  preConfigure = "autoreconf";

  makeFlags = "setowner= ";

  meta = {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
  };
}
