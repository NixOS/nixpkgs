{ lib, buildEnv, callPackage, makeWrapper }:

buildEnv {
  name = "flare-1.10";

  paths = [
    (callPackage ./engine.nix {})
    (callPackage ./game.nix {})
  ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/bin
    makeWrapper $out/games/flare $out/bin/flare --run "cd $out/share/games/flare"
  '';

  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "http://flarerpg.org/";
    maintainers = [ maintainers.aanderse ];
    license = [ licenses.gpl3 licenses.cc-by-sa-30 ];
    platforms = platforms.unix;
  };
}
