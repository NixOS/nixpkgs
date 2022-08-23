{ lib, stdenv, fetchurl, love, lua, makeWrapper, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "sienna";
  version = "1.0c";
  src = fetchurl {
    url = "https://github.com/SimonLarsen/${pname}/releases/download/v${version}/${pname}-${version}.love";
    sha256 = "1x15276fhqspgrrv8fzkp032i2qa8piywc0yy061x59mxhdndzj6";
  };

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/sienna.png";
    sha256 = "12q2rhk39dmb6ir50zafn8dylaad5gns8z3y21mfjabc5l5g02nn";
  };

  desktopItem = makeDesktopItem {
    name = "sienna";
    exec = pname;
    icon = icon;
    comment = "Fast-paced one button platformer";
    desktopName = "Sienna";
    genericName = "sienna";
    categories = [ "Game" ];
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lua love ];

  dontUnpack = true;

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

  meta = with lib; {
    description = "Fast-paced one button platformer";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = "http://tangramgames.dk/games/sienna";
  };

}
