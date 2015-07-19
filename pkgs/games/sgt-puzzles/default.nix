{stdenv, gtk, pkgconfig, libX11, perl, fetchsvn}:
let
  version = "10286";
  buildInputs = [
    gtk pkgconfig libX11 perl
  ];
in
stdenv.mkDerivation {
  src = fetchsvn {
   url = svn://svn.tartarus.org/sgt/puzzles;
   rev = version;
   sha256 = "1mp1s33hjikby7jy6bcjwyzkdwlw1bw9dcc4cg5d80wmzkb0sqv0";
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
  };
}
