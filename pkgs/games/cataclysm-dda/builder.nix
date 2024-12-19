{
  stdenvNoCC,
  lib,
  type,
}:

assert lib.elem type [
  "mod"
  "soundpack"
  "tileset"
];

{
  modName,
  version,
  src,
  ...
}@args:

stdenvNoCC.mkDerivation (
  args
  // rec {
    pname = args.pname or "cataclysm-dda-${type}-${modName}";

    modRoot = args.modRoot or ".";

    configurePhase =
      args.configurePhase or ''
        runHook preConfigure
        runHook postConfigure
      '';

    buildPhase =
      args.buildPhase or ''
        runHook preBuild
        runHook postBuild
      '';

    checkPhase =
      args.checkPhase or ''
        runHook preCheck
        runHook postCheck
      '';

    installPhase =
      let
        baseDir =
          {
            mod = "mods";
            soundpack = "sound";
            tileset = "gfx";
          }
          .${type};
      in
      args.installPhase or ''
        runHook preInstall
        destdir="$out/share/cataclysm-dda/${baseDir}"
        mkdir -p "$destdir"
        cp -R "${modRoot}" "$destdir/${modName}"
        runHook postInstall
      '';

    passthru = {
      forTiles = true;
      forCurses = type == "mod";
    };
  }
)
