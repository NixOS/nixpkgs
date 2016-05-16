{stdenv, gtk3, pkgconfig, libX11, perl, fetchurl, automake115x, autoconf}:
let
  version = "20160429.b31155b";
  buildInputs = [
    gtk3 pkgconfig libX11 perl automake115x autoconf
  ];
in
stdenv.mkDerivation {
  src = fetchurl {
   url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
   sha256 = "0y807srhf6571ijdwpa493qzsx161f0a1pmh2qi44f6ixfcrkgzi";
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
