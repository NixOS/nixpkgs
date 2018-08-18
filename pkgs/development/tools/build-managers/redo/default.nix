{stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "redo-1.3";
  src = fetchurl {
    url = "https://jdebp.eu./Repository/freebsd/${name}.tar.gz";
    sha256 = "1yx7nd59s01j096hr1zbnbx6mvd6ljzd4vgawh7p2l644jgwj70r";
  };

  nativeBuildInputs = [ perl /* for pod2man */ ];

  sourceRoot = ".";

  buildPhase = ''
    ./package/compile
  '';
  installPhase = ''
    ./package/export $out/
  '';

  meta = {
    homepage = https://jdebp.eu./Softwares/redo/;
    description = "A system for building target files from source files";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.vrthra ];
    platforms = stdenv.lib.platforms.unix;
  };
}
