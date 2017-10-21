{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "90secondportraits";
  version = "1.01b";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/90secondportraits.png";
    sha256 = "13k6cq8s7jw77j81xfa5ri41445m778q6iqbfplhwdpja03c6faw";
  };

  desktopItem = makeDesktopItem {
    name = "90secondportraits";
    exec = "${pname}";
    icon = "${icon}";
    comment = "A silly speed painting game";
    desktopName = "90 Second Portraits";
    genericName = "90secondportraits";
    categories = "Game;";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/SimonLarsen/90-Second-Portraits/releases/download/${version}/${pname}-${version}.love";
    sha256 = "0jj3k953r6vb02212gqcgqpb4ima87gnqgls43jmylxq2mcm33h5";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lua love ];

  phases = "installPhase";

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v $src $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "A silly speed painting game";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = http://tangramgames.dk/games/90secondportraits;
  };

}
