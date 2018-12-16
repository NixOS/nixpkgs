{ lib, buildEnv, stdenv, callPackage, makeWrapper, makeDesktopItem,
}:

let
  description = "Action-adventure game, starring a certain quixotic frog";
  engine = callPackage ./engine.nix { };
  data = callPackage ./data.nix { };
  desktopItem = makeDesktopItem {
    name = "frogatto";
    exec = "frogatto";
    startupNotify = "true";
    icon = "${data}/share/frogatto/modules/frogatto/images/os/frogatto-icon.png";
    comment = description;
    desktopName = "Frogatto";
    genericName = "frogatto";
    categories = "Application;Game;ArcadeGame;";
  };
  version = "0.0.2018-12-09";
in buildEnv rec {
  name = "frogatto-${version}";

  buildInputs = [ makeWrapper ];
  paths = [ engine data desktopItem ];
  pathsToLink = [ "/bin" "/share/frogatto/data" "/share/frogatto/images" "/share/frogatto/modules" ];

  postBuild = with stdenv.lib; let
    engine_path = lib.getOutput "bin" engine;
  in ''
    wrapProgram $out/bin/frogatto \
      --run "cd $out/share/frogatto"
    cp -r ${desktopItem}/share/applications $out/share/
  '';

  meta = with stdenv.lib; {
    homepage = https://frogatto.com;
    description = description;
    license = [ licenses.cc-by-30 licenses.unfree ];
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ astro ];
  };
}
