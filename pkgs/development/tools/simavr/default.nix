{ stdenv, fetchurl, makeWrapper, avrgcclibc, libelf, which, git, pkgconfig, freeglut, mesa }:

stdenv.mkDerivation rec {
  name = "simavr-${version}";
  version = "1.3";
  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://github.com/buserror/simavr/archive/v${version}.tar.gz";
    sha1 = "b1a875fb23ad819545bcb1889e5fb5470deb09c5";
  };

  unpackCmd = ''
    tar -xvf $src
    cd simavr-$version
  '';

  buildFlags = "AVR_ROOT=${avrgcclibc}/avr SIMAVR_VERSION=${version}";
  installFlags = buildFlags + " DESTDIR=$(out)";

  buildInputs = [ makeWrapper which git avrgcclibc libelf pkgconfig freeglut mesa ];

  sourceRoot = ".";

  meta = with stdenv.lib; {
    description = "A lean and mean Atmel AVR simulator for Linux";
    homepage    = https://github.com/buserror/simavr;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ goodrone ];
  };

}

