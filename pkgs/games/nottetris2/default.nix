{ lib, stdenv, fetchFromGitHub, zip, love_0_7, makeWrapper, makeDesktopItem }:

let
  pname = "nottetris2";
  version = "2.0";

  desktopItem = makeDesktopItem {
    name = "nottetris2";
    exec = pname;
    comment = "It's like tetris, but it's not";
    desktopName = "nottetris2";
    genericName = "nottetris2";
    categories = "Game";
  };

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = pname;
    rev = "v${version}";
    sha256 = "17iabh6rr8jim70n96rbhif4xq02g2kppscm8l339yqx6mhb64hs";
  };

  nativeBuildInputs = [ zip makeWrapper ];
  buildInputs = [ love_0_7 ];

  installPhase =
  ''
    mkdir -p $out/bin $out/share/games/lovegames $out/share/applications
    zip -9 -r ${pname}.love ./*
    mv ${pname}.love $out/share/games/lovegames/${pname}.love
    makeWrapper ${love_0_7}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    description = "It's like Tetris, but it's not";
    platforms = platforms.linux;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ yorickvp ];
    downloadPage = "https://stabyourself.net/nottetris2/";
  };

}
