{ stdenv, fetchurl
, gtk3, libX11
, makeWrapper, pkgconfig, perl, autoreconfHook, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "sgt-puzzles-r${version}";
  version = "20190415.e2135d5";

  src = fetchurl {
   url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
   sha256 = "02p9kpvmqa0cm9y0lzdy7g8h4b4mqma8d9jfvgi2yysbgjfzq2ak";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig perl wrapGAppsHook ];

  buildInputs = [ gtk3 libX11 ];

  makeFlags = ["prefix=$(out)" "gamesdir=$(out)/bin"];
  preInstall = ''
    mkdir -p "$out"/{bin,share/doc/sgtpuzzles}
    cp gamedesc.txt LICENCE README "$out/share/doc/sgtpuzzles"
  '';
  # SGT Puzzles use generic names like net, map, etc.
  # Create symlinks with sgt-puzzle- prefix for possibility of
  # disambiguation
  postInstall = ''
    (
      cd "$out"/bin ;
      for i in *; do ln -s "$i" "sgt-puzzle-$i"; done
    )
  '';
  preConfigure = ''
    perl mkfiles.pl
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
    cp Makefile.gtk Makefile
  '';
  meta = with stdenv.lib; {
    description = "Simon Tatham's portable puzzle collection";
    license = licenses.mit;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    homepage = http://www.chiark.greenend.org.uk/~sgtatham/puzzles/;
  };
}
