{ lib, stdenv, fetchurl, desktop-file-utils
, gtk3, libX11, cmake, imagemagick
, pkg-config, perl, wrapGAppsHook, nixosTests
, isMobile ? false
}:

stdenv.mkDerivation rec {
  pname = "sgt-puzzles";
  # To find the latest version:
  #     $ curl -s -i 'https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz' | grep Location
  version = "20230918.2d9e414";

  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
    hash = "sha256-YsvJ/5DTevRb+sCxWc/KcD2X5IXwAXvWGVfokr06nUM=";
  };

  sgt-puzzles-menu = fetchurl {
    url = "https://raw.githubusercontent.com/gentoo/gentoo/720e614d0107e86fc1e520bac17726578186843d/games-puzzle/sgt-puzzles/files/sgt-puzzles.menu";
    sha256 = "088w0x9g3j8pn725ix8ny8knhdsfgjr3hpswsh9fvfkz5vlg2xkm";
  };

  nativeBuildInputs = [
    cmake
    desktop-file-utils
    imagemagick
    perl
    pkg-config
    wrapGAppsHook
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString isMobile "-DSTYLUS_BASED";

  buildInputs = [ gtk3 libX11 ];

  postInstall = ''
    for i in  $(basename -s $out/bin/*); do

      ln -s $out/bin/$i $out/bin/sgt-puzzle-$i
      install -Dm644 icons/$i-96d24.png -t $out/share/icons/hicolor/96x96/apps/

      # Generate/validate/install .desktop files.
      echo "[Desktop Entry]" > $i.desktop
      desktop-file-install --dir $out/share/applications \
        --set-key Type --set-value Application \
        --set-key Exec --set-value $i \
        --set-key Name --set-value $i \
        --set-key Comment --set-value "${meta.description}" \
        --set-key Categories --set-value "Game;LogicGame;X-sgt-puzzles;" \
        --set-key Icon --set-value $out/share/icons/hicolor/96x96/apps/$i-96d24.png \
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

  passthru.tests.sgtpuzzles = nixosTests.sgtpuzzles;

  meta = with lib; {
    description = "Simon Tatham's portable puzzle collection";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin tomfitzhenry ];
    platforms = platforms.linux;
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/";
  };
}
