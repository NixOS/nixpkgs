{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "duckmarines";
  version = "1.0b";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/duckmarines.png";
    sha256 = "07ypbwqcgqc5f117yxy9icix76wlybp1cmykc8f3ivdps66hl0k5";
  };

  desktopItem = makeDesktopItem {
    name = "duckmarines";
    exec = "${pname}";
    icon = "${icon}";
    comment = "Duck-themed action puzzle video game";
    desktopName = "Duck Marines";
    genericName = "duckmarines";
    categories = "Game;";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/SimonLarsen/${pname}/releases/download/v${version}/${pname}-1.0-love.zip";
    sha256 = "0fpzbsgrhbwm1lff9gyzh6c9jigw328ngddvrj5w7qmjcm2lv6lv";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ lua love ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v ./${pname}-1.0.love $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Duck-themed action puzzle video game";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = http://tangramgames.dk/games/duckmarines;
  };

}
