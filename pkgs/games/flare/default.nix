{ lib, buildEnv, callPackage, makeWrapper, Cocoa }:

buildEnv {
  name = "flare-1.13";

  paths = [
    (callPackage ./engine.nix { inherit Cocoa; })
    (callPackage ./game.nix {})
  ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/bin
    makeWrapper $out/games/flare $out/bin/flare --run "cd $out/share/games/flare"
  '';

  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://flarerpg.org/";
    maintainers = with maintainers; [ aanderse McSinyx ];
    license = [ licenses.gpl3 licenses.cc-by-sa-30 ];
    platforms = platforms.unix;
  };
}
