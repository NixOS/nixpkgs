{ stdenv, fetchurl, linkStatic ? false }:

let
  version = "1.0.6";

  sharedLibrary = !stdenv.isDarwin && !(stdenv ? isStatic)
               && stdenv.system != "i686-cygwin" && !linkStatic;

in stdenv.mkDerivation {
  name = "bzip2-${version}";

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  crossAttrs = {
    patchPhase = ''
      sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
      sed -i -e 's/CC=gcc/CC=${stdenv.cross.config}-gcc/' \
        -e 's/AR=ar/AR=${stdenv.cross.config}-ar/' \
        -e 's/RANLIB=ranlib/RANLIB=${stdenv.cross.config}-ranlib/' \
        -e 's/bzip2recover test/bzip2recover/' \
        Makefile*
    '';
  };

  outputs = [ "dev" "bin" "static" ] ++ stdenv.lib.optional sharedLibrary "out";

  preBuild = stdenv.lib.optionalString sharedLibrary ''
    make -f Makefile-libbz2_so
  '';

  preInstall = stdenv.lib.optionalString sharedLibrary ''
    mkdir -p $out/lib
    mv libbz2.so* $out/lib
    ( cd $out/lib &&
      ln -s libbz2.so.1.0.? libbz2.so &&
      ln -s libbz2.so.1.0.? libbz2.so.1
    )
  '';

  installFlags = [ "PREFIX=$(bin)" ];

  postInstall = ''
    rm $bin/bin/bunzip2* $bin/bin/bzcat*
    ln -s bzip2 $bin/bin/bunzip2
    ln -s bzip2 $bin/bin/bzcat

    mkdir "$static"
    mv "$bin/lib" "$static/"
  '';

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace 'CC=gcc' 'CC=clang'
  '';

  preConfigure = ''
    substituteInPlace Makefile --replace '$(PREFIX)/man' '$(PREFIX)/share/man'
  '';

  makeFlags = stdenv.lib.optional linkStatic "LDFLAGS=-static";

  inherit linkStatic;

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
