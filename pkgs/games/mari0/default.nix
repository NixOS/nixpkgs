{ lib, stdenv, fetchFromGitHub, zip, love_11, lua, makeWrapper, makeDesktopItem }:

let
  pname = "mari0";
  version = "1.6.2";

  desktopItem = makeDesktopItem {
    name = "mari0";
    exec = pname;
    comment = "Crossover between Super Mario Bros. and Portal";
    desktopName = "mari0";
    genericName = "mari0";
    categories = [ "Game" ];
  };

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = pname;
    rev = version;
    sha256 = "1zqaq4w599scsjvy1rsb21fd2r8j3srx9vym4ir9bh666dp36gxa";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lua love_11 zip ];

  installPhase =
  ''
    mkdir -p $out/bin $out/share/games/lovegames $out/share/applications
    zip -9 -r ${pname}.love ./*
    mv ${pname}.love $out/share/games/lovegames/${pname}.love
    makeWrapper ${love_11}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Crossover between Super Mario Bros. and Portal";
    platforms = platforms.linux;
    license = licenses.mit;
    downloadPage = "https://stabyourself.net/mari0/";
  };

}
