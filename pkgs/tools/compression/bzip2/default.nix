{stdenv, fetchurl, linkStatic ? false}:

stdenv.mkDerivation {
  name = "bzip2-1.0.5";
  
  builder = ./builder.sh;
    
  src = fetchurl {
    url = http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz;
    sha256 = "08py2s9vw6dgw457lbklh1vsr3b8x8dlv7d8ygdfaxlx61l57gzp";
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

  makeFlags = if linkStatic then "LDFLAGS=-static" else "";

  inherit linkStatic;
    
  meta = {
    homepage = http://www.bzip.org;
  };
}
