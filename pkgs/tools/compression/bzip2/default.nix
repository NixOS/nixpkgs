{ stdenv, fetchurl, linkStatic ? false }:

let
  version = "1.0.6";
  inherit (stdenv.lib) optionalString;
  sharedLibrary = with stdenv;
    !( isDarwin || (stdenv ? isStatic) || system == "i686-cygwin" || linkStatic );
in

stdenv.mkDerivation rec {
  name = "bzip2-${version}";

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  patchPhase = optionalString stdenv.isDarwin
    "substituteInPlace Makefile --replace 'CC=gcc' 'CC=clang'";

  outputs = [ "dev" "bin" "static" ] ++ stdenv.lib.optional sharedLibrary "out";

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

  preConfigure = "substituteInPlace Makefile --replace '$(PREFIX)/man' '$(PREFIX)/share/man'";

  preBuild = optionalString sharedLibrary "make -f Makefile-libbz2_so";
  makeFlags = optionalString linkStatic "LDFLAGS=-static";

  installFlags = "PREFIX=$(bin)";

  postInstall = optionalString sharedLibrary ''
    mkdir -p $out/lib
    mv libbz2.so* $out/lib
    ( cd $out/lib && ln -s libbz2.so.1.*.* libbz2.so && ln -s libbz2.so.1.*.* libbz2.so.1 )
  '' + ''
    mkdir -p "$static"
    mv "$bin/lib" "$static/"
    (
      cd "$bin/bin"
      rm {bunzip2,bzcat}*
      ln -s bzip2 bunzip2
      ln -s bzip2 bzcat
    )
  '';

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
