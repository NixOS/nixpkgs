{
  stdenv,
  lib,
  callPackage,
  fetchurl,
  x11Mode ? false,
  qtMode ? false,
}:

callPackage ./generic.nix rec {
  gameName = "nethack";
  version = "3.6.7";
  src = fetchurl {
    url = "https://nethack.org/download/${version}/nethack-${
      lib.replaceStrings [ "." ] [ "" ] version
    }-src.tgz";
    sha256 = "sha256-mM9n323r+WaKYXRaqEwJvKs2Ll0z9blE7FFV1E0qrLI=";
  };

  inherit stdenv x11Mode qtMode;

  desktopItems = [
    {
      name = "NetHack";
      exec =
        if x11Mode then
          "${gameName}-x11"
        else if qtMode then
          "${gameName}-qt"
        else
          gameName;
      icon = gameName;
      desktopName = "NetHack";
      comment = "NetHack is a single player dungeon exploration game";
      categories = [
        "Game"
        "ActionGame"
      ];
    }
  ];

  meta = {
    description = "Rogue-like game";
    homepage = "http://nethack.org/";
    license = "nethack";
    maintainers = with lib.maintainers; [ abbradar ];
    mainProgram = "nethack";
  };
}
