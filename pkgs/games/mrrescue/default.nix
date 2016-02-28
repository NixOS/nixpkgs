{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "mrrescue";
  version = "1.02d";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/mrrescue.png";
    sha256 = "1y5ahf0m01i1ch03axhvp2kqc6lc1yvh59zgvgxw4w7y3jryw20k";
  };

  desktopItem = makeDesktopItem {
    name = "mrrescue";
    exec = "${pname}";
    icon = "${icon}";
    comment = "Arcade-style fire fighting game"; 
    desktopName = "Mr. Rescue";
    genericName = "mrrescue";
    categories = "Game;";
  };

in 

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/SimonLarsen/${pname}/releases/download/v${version}/${pname}-${version}.love";
    sha256 = "0kzahxrgpb4vsk9yavy7f8nc34d62d1jqjrpsxslmy9ywax4yfpi";
  };

  nativeBuildInputs = [ lua love ];
  buildInputs = [ makeWrapper ];

  phases = "installPhase";

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v $src $out/share/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Arcade-style fire fighting game";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.zlib;
    downloadPage = http://tangramgames.dk/games/mrrescue;
  };

}
