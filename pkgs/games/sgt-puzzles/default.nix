{stdenv, gtk3, pkgconfig, libX11, perl, fetchurl, automake114x, autoconf}:
let
  version = "20160410.9d15092";
  buildInputs = [
    gtk3 pkgconfig libX11 perl automake114x autoconf
  ];
in
stdenv.mkDerivation {
  src = fetchurl {
   url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
   sha256 = "184n29mfgj56alp5853mya878rlxf5zxy0r3zfhi9h2yfqiwszi4";
  };
  name = "sgt-puzzles-r" + version;
  inherit buildInputs;
  makeFlags = ["prefix=$(out)" "gamesdir=$(out)/bin"];
  preInstall = ''
    mkdir -p "$out"/{bin,share/doc/sgtpuzzles}
    cp gamedesc.txt LICENCE README "$out/share/doc/sgtpuzzles"
    cp LICENCE "$out/share/doc/sgtpuzzles/LICENSE"
  '';
  preConfigure = ''
    perl mkfiles.pl
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
    cp Makefile.gtk Makefile
  '';
  meta = {
    inherit version;
    description = "Simon Tatham's portable puzzle collection";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/";
  };
}
