{ stdenv, fetchurl, linkStatic ? false }:

let version = "1.0.6"; in

stdenv.mkDerivation {
  name = "bzip2-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  crossAttrs = {
    patchPhase = ''
      sed -i -e 's/CC=gcc/CC=${stdenv.cross.config}-gcc/' \
        -e 's/AR=ar/AR=${stdenv.cross.config}-ar/' \
        -e 's/RANLIB=ranlib/RANLIB=${stdenv.cross.config}-ranlib/' \
        -e 's/bzip2recover test/bzip2recover/' \
        Makefile*
    '';
  };

  sharedLibrary =
    !stdenv.isDarwin && !(stdenv ? isDietLibC) && !(stdenv ? isStatic) && stdenv.system != "i686-cygwin" && !linkStatic;

  preConfigure = "substituteInPlace Makefile --replace '$(PREFIX)/man' '$(PREFIX)/share/man'";

  makeFlags = if linkStatic then "LDFLAGS=-static" else "";

  inherit linkStatic;

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
