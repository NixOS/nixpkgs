{stdenv, gtk3, pkgconfig, libX11, perl, fetchurl, automake115x, autoconf}:
let
  version = "20161228.7cae89f";
  buildInputs = [
    gtk3 pkgconfig libX11 perl automake115x autoconf
  ];
in
stdenv.mkDerivation {
  src = fetchurl {
   url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
   sha256 = "0kqy3gdgfjgaqbjl95pnljz44v91i79qphwdp91k0n5alswxwn76";
  };
  name = "sgt-puzzles-r" + version;
  inherit buildInputs;
  makeFlags = ["prefix=$(out)" "gamesdir=$(out)/bin"];
  preInstall = ''
    mkdir -p "$out"/{bin,share/doc/sgtpuzzles}
    cp gamedesc.txt LICENCE README "$out/share/doc/sgtpuzzles"
    cp LICENCE "$out/share/doc/sgtpuzzles/LICENSE"
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
  meta = {
    inherit version;
    description = "Simon Tatham's portable puzzle collection";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/";
  };
}
