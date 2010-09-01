{ stdenv, fetchurl, bison, flex, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "kbd-1.15.2";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.bz2";
    sha256 = "19pb44m5m0mcgjkmgkjx4fn8j2m4xwqx4g7w2y1nlypg3qcjsq5k";
  };

  buildInputs = [ bison flex autoconf automake  ];

  # We get a warning in armv5tel-linux and the fuloong2f,
  # so we disable -Werror in it
  patchPhase = if (stdenv.system == "armv5tel-linux" ||
    stdenv.system == "mips64-linux")
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
