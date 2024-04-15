{ lib
, stdenv
, fetchurl
, perl
}:

stdenv.mkDerivation rec {
  pname = "redo";
  version = "1.4";
  src = fetchurl {
    url = "http://jdebp.info/Repository/freebsd/${pname}-${version}.tar.gz";
    hash = "sha256-W5KJ8SKO7i8iq5b33U+bQ+Om0k91wfnR4Y7sc2DJD7E=";
  };

  nativeBuildInputs = [
    perl # for pod2man
  ];

  sourceRoot = ".";

  buildPhase = ''
    ./package/compile
  '';
  installPhase = ''
    ./package/export $out/
  '';

  meta = {
    homepage = "http://jdebp.info/Softwares/redo/";
    description = "A system for building target files from source files";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vrthra ];
    platforms = lib.platforms.unix;
  };
}
