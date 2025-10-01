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

let
  pname = "mrrescue";
  version = "1.02d";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/mrrescue.png";
    sha256 = "1y5ahf0m01i1ch03axhvp2kqc6lc1yvh59zgvgxw4w7y3jryw20k";
  };

  desktopItem = makeDesktopItem {
    name = "mrrescue";
    exec = pname;
    icon = icon;
    comment = "Arcade-style fire fighting game";
    desktopName = "Mr. Rescue";
    genericName = "mrrescue";
    categories = [ "Game" ];
  };

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "SimonLarsen";
    repo = "mrrescue";
    tag = "v${version}";
    hash = "sha256-/g4SzaI1tSJZg1wW0onQwLMMam5v8PvM45tqP2FxZCA=";
  };

  nativeBuildInputs = [
    lua
    love
    makeWrapper
    strip-nondeterminism
    zip
  ];

  buildPhase = ''
    runHook preBuild
    zip -9 -r mrrescue.love ./*
    strip-nondeterminism --type zip mrrescue.love
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v mrrescue.love $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "Arcade-style fire fighting game";
    mainProgram = "mrrescue";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.zlib;
    downloadPage = "http://tangramgames.dk/games/mrrescue";
  };

}
