{ stdenv, fetchurl, desktop-file-utils
, gtk3, libX11
, makeWrapper, pkgconfig, perl, autoreconfHook, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "sgt-puzzles-r${version}";
  version = "20191114.1c0c49d";

  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
    sha256 = "01fi2f3w71bfbgcfr6gxdp5a9cxh4dshbflv83q2j5rxxs2ll870";
  };

  nativeBuildInputs = [ autoreconfHook desktop-file-utils makeWrapper
    pkgconfig perl wrapGAppsHook ];

  buildInputs = [ gtk3 libX11 ];

  makeFlags = ["prefix=$(out)" "gamesdir=$(out)/bin"];

  preInstall = ''
    mkdir -p "$out"/{bin,share/doc/sgtpuzzles,share/icons/hicolor/48x48/apps}
    cp gamedesc.txt LICENCE README "$out/share/doc/sgtpuzzles"
  '';
  # SGT Puzzles use generic names like net, map, etc.
  # Create symlinks with sgt-puzzle- prefix for possibility of
  # disambiguation
  postInstall = ''
    (
      currentSrc=$PWD
      cd "$out"/bin ;
      for i in *; do
        ln -s "$i" "sgt-puzzle-$i"

        install -Dm644 $currentSrc/icons/$i-48d24.png $out/share/icons/hicolor/48x48/apps/

        # Generate/validate/install .desktop files.
        echo "[Desktop Entry]" > $i.desktop
        desktop-file-install --dir $out/share/applications \
          --set-key Type --set-value Application \
          --set-key Exec --set-value $i \
          --set-key Name --set-value $i \
          --set-key Comment --set-value "${meta.description}" \
          --set-key Categories --set-value Game \
          --set-key Icon --set-value $out/share/icons/hicolor/48x48/apps/$i-48d24 $i.desktop
        rm $i.desktop
      done
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
    homepage = https://www.chiark.greenend.org.uk/~sgtatham/puzzles/;
  };
}
