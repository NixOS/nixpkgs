{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "orthorobot";
  version = "1.0";

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

  src = fetchurl {
    url = "http://stabyourself.net/dl.php?file=${pname}/${pname}-source.zip";
    sha256 = "023nc3zwjkbmy4c8w6mfg39mg69zpqqr2gzlmp4fpydrjas70kbl";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ lua love ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip -j $src
  '';  

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v ./*.love $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Recharge the robot";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = http://stabyourself.net/orthorobot/;
  };

}
