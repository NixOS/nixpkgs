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

  sgt-puzzles-menu = fetchurl {
    url = "https://raw.githubusercontent.com/Oleh-Kravchenko/portage/master/games-puzzle/sgt-puzzles/files/sgt-puzzles.menu";
    sha256 = "088w0x9g3j8pn725ix8ny8knhdsfgjr3hpswsh9fvfkz5vlg2xkm";
  };

  nativeBuildInputs = [ autoreconfHook desktop-file-utils makeWrapper
    pkgconfig perl wrapGAppsHook ];

  buildInputs = [ gtk3 libX11 ];

  makeFlags = [ "prefix=$(out)" "gamesdir=$(out)/bin"];

  preInstall = ''
    mkdir -p "$out"/{bin,share/doc/sgtpuzzles}
    cp gamedesc.txt LICENCE README "$out/share/doc/sgtpuzzles"
  '';

  postInstall = ''
    for i in  $(basename -s $out/bin/*); do

      ln -s $out/bin/$i $out/bin/sgt-puzzle-$i
      install -Dm644 icons/$i-48d24.png -t $out/share/icons/hicolor/48x48/apps/

      # Generate/validate/install .desktop files.
      echo "[Desktop Entry]" > $i.desktop
      desktop-file-install --dir $out/share/applications \
        --set-key Type --set-value Application \
        --set-key Exec --set-value $i \
        --set-key Name --set-value $i \
        --set-key Comment --set-value "${meta.description}" \
        --set-key Categories --set-value "Game;LogicGame;X-sgt-puzzles;" \
        --set-key Icon --set-value $out/share/icons/hicolor/48x48/apps/$i-48d24 \
        $i.desktop
    done

    echo "[Desktop Entry]" > sgt-puzzles.directory
    desktop-file-install --dir $out/share/desktop-directories \
      --set-key Type --set-value Directory \
      --set-key Name --set-value Puzzles \
      --set-key Icon --set-value $out/share/icons/hicolor/48x48/apps/sgt-puzzles_map \
      sgt-puzzles.directory

    install -Dm644 ${sgt-puzzles-menu} -t $out/etc/xdg/menus/applications-merged/
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
    maintainers = [ maintainers.raskin maintainers.genesis ];
    platforms = platforms.linux;
    homepage = https://www.chiark.greenend.org.uk/~sgtatham/puzzles/;
  };
}
