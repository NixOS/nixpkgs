{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  love,
  lua,
  makeWrapper,
  makeDesktopItem,
  strip-nondeterminism,
  zip,
}:

stdenv.mkDerivation rec {
  pname = "duckmarines";
  version = "1.0c";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/duckmarines.png";
    sha256 = "07ypbwqcgqc5f117yxy9icix76wlybp1cmykc8f3ivdps66hl0k5";
  };

  desktopItem = makeDesktopItem {
    name = "duckmarines";
    exec = "duckmarines";
    icon = icon;
    comment = "Duck-themed action puzzle video game";
    desktopName = "Duck Marines";
    genericName = "duckmarines";
    categories = [ "Game" ];
  };

  src = fetchFromGitHub {
    owner = "SimonLarsen";
    repo = "duckmarines";
    tag = "v${version}";
    hash = "sha256-0WzqYbK18IL8VY7NsVONwJCI5+me5SPulfkkLCifLvY=";
  };

  nativeBuildInputs = [
    makeWrapper
    strip-nondeterminism
    zip
  ];
  buildInputs = [
    lua
    love
  ];

  buildPhase = ''
    runHook preBuild
    zip -9 -r duckmarines.love ./*
    strip-nondeterminism --type zip duckmarines.love
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v duckmarines.love $out/share/games/lovegames/duckmarines.love

    makeWrapper ${love}/bin/love $out/bin/duckmarines --add-flags $out/share/games/lovegames/duckmarines.love

    chmod +x $out/bin/duckmarines
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "Duck-themed action puzzle video game";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    hydraPlatforms = [ ];
    license = licenses.free;
    downloadPage = "http://tangramgames.dk/games/duckmarines";
  };

}
