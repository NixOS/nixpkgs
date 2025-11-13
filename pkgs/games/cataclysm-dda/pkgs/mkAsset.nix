{
  lib,
  stdenvNoCC,
  assetType,
}:

assert lib.elem assetType [
  "mod"
  "soundpack"
  "tileset"
];

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "modName"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      modName,
      version,
      src,
      ...
    }@args:
    {
      pname = args.pname or "cataclysm-${assetType}-${modName}";

      modRoot = args.modRoot or ".";

      installPhase =
        let
          baseDir =
            {
              mod = "mods";
              soundpack = "sound";
              tileset = "gfx";
            }
            .${assetType};
        in
        args.installPhase or ''
          runHook preInstall

          destdir="$out/share/cataclysm-dda/${baseDir}"
          mkdir -p "$destdir"
          cp -R "${finalAttrs.modRoot}" "$destdir/${modName}"

          runHook postInstall
        '';
    };
}
