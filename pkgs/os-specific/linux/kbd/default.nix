{ stdenv, fetchurl, bison, flex, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "kbd-1.15.1";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.gz";
    sha256 = "1klrxas8vjikx6jm6m2lcpmn88lhxb6p3whwgdwq9d9flf1qrf4i";
  };

  buildInputs = [ bison flex autoconf automake  ];

  # We get a warning in armv5tel-linux, so we disable -Werror in it
  patchPhase = if (stdenv.system == "armv5tel-linux") then ''
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
