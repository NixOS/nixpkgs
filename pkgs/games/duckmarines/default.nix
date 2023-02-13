{ lib, stdenv, fetchurl, love, lua, makeWrapper, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "duckmarines";
  version = "1.0c";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/duckmarines.png";
    sha256 = "07ypbwqcgqc5f117yxy9icix76wlybp1cmykc8f3ivdps66hl0k5";
  };

  desktopItem = makeDesktopItem {
    name = "duckmarines";
    exec = pname;
    icon = icon;
    comment = "Duck-themed action puzzle video game";
    desktopName = "Duck Marines";
    genericName = "duckmarines";
    categories = [ "Game" ];
  };

  src = fetchurl {
    url = "https://github.com/SimonLarsen/${pname}/releases/download/v${version}/${pname}-1.0c.love";
    sha256 = "1rvgpkvi4h9zhc4fwb4knhsa789yjcx4a14fi4vqfdyybhvg5sh9";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lua love ];

  dontUnpack = true;

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v ${src} $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "Duck-themed action puzzle video game";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    hydraPlatforms = [];
    license = licenses.free;
    downloadPage = "http://tangramgames.dk/games/duckmarines";
  };

}
