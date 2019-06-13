{ stdenv, fetchurl, fetchFromGitHub, zip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "orthorobot";
  version = "1.1.1";

  icon = fetchurl {
    url = "http://stabyourself.net/images/screenshots/orthorobot-5.png";
    sha256 = "13fa4divdqz4vpdij1lcs5kf6w2c4jm3cc9q6bz5h7lkng31jzi6";
  };

  desktopItem = makeDesktopItem {
    name = "orthorobot";
    exec = "${pname}";
    icon = "${icon}";
    comment = "Robot game";
    desktopName = "Orthorobot";
    genericName = "orthorobot";
    categories = "Game;";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ca6hvd890kxmamsmsfiqzw15ngsvb4lkihjb6kabgmss61a6s5p";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lua love zip ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase =
  ''
    mkdir -p $out/bin $out/share/games/lovegames $out/share/applications
    zip -9 -r ${pname}.love ./*
    mv ${pname}.love $out/share/games/lovegames/${pname}.love
    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
    chmod +x $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    description = "Recharge the robot";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = http://stabyourself.net/orthorobot/;
  };

}
