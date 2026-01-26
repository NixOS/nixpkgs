{
  stdenv,
  lib,
  buildEnv,
  makeWrapper,
  yquake2,
  copyDesktopItems,
  makeDesktopItem,
}:

{
  games,
  name,
  description,
}:

let
  env = buildEnv {
    name = "${name}-env";
    paths = [ yquake2 ] ++ games;
  };

in
stdenv.mkDerivation {
  pname = name;
  version = lib.getVersion yquake2;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
  ''
  + lib.concatMapStringsSep "\n" (game: ''
    makeWrapper ${env}/bin/yquake2 $out/bin/yquake2-${game.title} \
      --add-flags "+set game ${game.id}"
    makeWrapper ${env}/bin/yq2ded $out/bin/yq2ded-${game.title} \
      --add-flags "+set game ${game.id}"
  '') games
  + ''
    install -Dm644 ${yquake2}/share/pixmaps/yamagi-quake2.png $out/share/pixmaps/yamagi-quake2.png;
    runHook postInstall
  '';

  desktopItems = map (
    game:
    makeDesktopItem {
      name = game.id;
      exec = game.title;
      icon = "yamagi-quake2";
      desktopName = game.id;
      comment = game.description;
      categories = [
        "Game"
        "Shooter"
      ];
    }
  ) games;

  meta = {
    inherit description;
  };
}
