{ stdenv, lib, buildEnv, makeWrapper, yquake2 }:

{ games
, name
, description
}:

let
  env = buildEnv {
    name = "${name}-env";
    paths = [ yquake2 ] ++ games;
  };

in stdenv.mkDerivation {
  name = "${name}-${lib.getVersion yquake2}";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
  '' + lib.concatMapStringsSep "\n" (game: ''
    makeWrapper ${env}/bin/yquake2 $out/bin/yquake2-${game.title} \
      --add-flags "+set game ${game.id}"
    makeWrapper ${env}/bin/yq2ded $out/bin/yq2ded-${game.title} \
      --add-flags "+set game ${game.id}"
  '') games;

  meta = {
    inherit description;
  };
}
