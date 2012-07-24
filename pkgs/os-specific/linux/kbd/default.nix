{ stdenv, fetchurl, bison, flex, autoconf, automake, gzip, bzip2 }:

stdenv.mkDerivation rec {
  name = "kbd-1.15.2";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.gz";
    sha256 = "0ff674y6d3b6ix08b9l2yzv8igns768biyp5y92vip7iz4xv2p2j";
  };

  buildNativeInputs = [ bison flex autoconf automake ];

  patchPhase =
    ''
      # Fix the path to gzip/bzip2.
      substituteInPlace src/findfile.c \
        --replace gzip ${gzip}/bin/gzip \
        --replace bzip2 ${bzip2}/bin/bzip2 \
    
      # We get a warning in armv5tel-linux and the fuloong2f, so we
      # disable -Werror in it.
      ${stdenv.lib.optionalString (stdenv.isArm || stdenv.system == "mips64el-linux") ''
        sed -i s/-Werror// src/Makefile.am
      ''}
    '';

  # Grrr, kbd 1.15.1 doesn't include a configure script.
  preConfigure = "autoreconf";

  makeFlags = "setowner= ";

  meta = {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
  };
}
