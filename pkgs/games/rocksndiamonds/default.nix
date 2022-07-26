{ lib, stdenv, fetchurl, fetchpatch, makeDesktopItem, SDL2, SDL2_image, SDL2_mixer, SDL2_net }:

stdenv.mkDerivation rec {
  pname = "rocksndiamonds";
  version = "4.1.1.0";

  src = fetchurl {
    url = "https://www.artsoft.org/RELEASES/unix/${pname}/rocksndiamonds-${version}.tar.gz";
    sha256 = "1k0m6l5g886d9mwwh6q0gw75qsb85mpf8i0rglh047app56nsk72";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchain.
    (fetchpatch {
      name = "fno-common-p1.patch";
      url = "https://git.artsoft.org/?p=rocksndiamonds.git;a=patch;h=b4271393b10b7c664a58f3db7349a3875c1676fe";
      sha256 = "0bdy4d2ril917radmm0c2yh2gqfyh7q1c8kahig5xknn2rkf2iac";
    })
    (fetchpatch {
      name = "fno-common-p2.patch";
      url = "https://git.artsoft.org/?p=rocksndiamonds.git;a=patch;h=81dbde8a570a94dd2e938eff2f52dc5a3ecced21";
      sha256 = "1mk5yb8pxrpxvvsxw3pjcbgx2c658baq9vmqqipbj5byhkkw7v2l";
    })
  ];

  desktopItem = makeDesktopItem {
    name = "rocksndiamonds";
    exec = "rocksndiamonds";
    icon = "rocksndiamonds";
    comment = meta.description;
    desktopName = "Rocks'n'Diamonds";
    genericName = "Tile-based puzzle";
    categories = [ "Game" "LogicGame" ];
  };

  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net ];

  preBuild = ''
    dataDir="$out/share/rocksndiamonds"
    makeFlags+="RO_GAME_DIR=$dataDir"
  '';

  installPhase = ''
    appDir=$out/share/applications
    iconDir=$out/share/icons/hicolor/32x32/apps
    mkdir -p $out/bin $appDir $iconDir $dataDir
    cp rocksndiamonds $out/bin/
    ln -s ${desktopItem}/share/applications/* $appDir/
    ln -s $dataDir/graphics/gfx_classic/RocksIcon32x32.png $iconDir/rocksndiamonds.png
    cp -r docs graphics levels music sounds $dataDir
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scrolling tile-based arcade style puzzle game";
    homepage = "https://www.artsoft.org/rocksndiamonds/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
