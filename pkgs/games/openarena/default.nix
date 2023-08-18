{ lib
, stdenvNoCC
, fetchzip
, curl
, libglvnd
, libicns
, libogg
, libvorbis
, makeBinaryWrapper
, openal
, SDL
, copyDesktopItems
, autoPatchelfHook
, makeDesktopItem
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openarena";
  version = "0.8.8";

  src = fetchzip {
    url = "https://download.tuxfamily.org/openarena/rel/${builtins.replaceStrings ["."] [""] finalAttrs.version}/openarena-${finalAttrs.version}.zip";
    hash = "sha256-Rup1n14k9sKcyVFYzFqPYV+BEBCnUNwpnFsnyGrhl20=";
  };

  nativeBuildInputs = [
    curl
    libglvnd
    libicns
    libogg
    libvorbis
    makeBinaryWrapper
    openal
    SDL
  ] ++ lib.optionals stdenvNoCC.isLinux [
    copyDesktopItems
    autoPatchelfHook
  ];

  installPhase =
    if stdenvNoCC.isDarwin then ''
      runHook preInstall

      mkdir -p $out/Applications
      mv *.app $out/Applications

      runHook postInstall
    '' else
      let
        arch = {
          "x86_64-linux" = "x86_64";
          "i386-linux" = "i386";
        }.${stdenvNoCC.hostPlatform.system};
      in
      ''
        runHook preInstall

        mkdir -p $out/share/openarena
        cp -r {baseoa,missionpack} $out/share/openarena/
        install openarena.${arch} $out/share/openarena/
        install oa_ded.${arch} $out/share/openarena/

        icns2png --extract OpenArena.app/Contents/Resources/ioquake3.icns

        for size in 16 32 128 256 512; do
          mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
          install -Dm644 ioquake3_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/openarena.png
        done;

        makeWrapper "$out/share/openarena/openarena.${arch}" "$out/bin/openarena"
        makeWrapper "$out/share/openarena/oa_ded.${arch}" "$out/bin/oa_ded"

        runHook postInstall
      '';

  desktopItems = [
    (makeDesktopItem {
      name = "OpenArena";
      exec = "openarena";
      icon = "openarena";
      comment = "A fast-paced 3D first-person shooter, similar to id Software Inc.'s Quake III Arena";
      desktopName = "openarena";
      categories = [ "Game" "ActionGame" ];
    })
  ];

  meta = {
    broken = stdenvNoCC.isDarwin; # the upstream binary only supports 32-bit
    description = "A fast-paced 3D first-person shooter, similar to id Software Inc.'s Quake III Arena";
    homepage = "http://openarena.ws/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "openarena";
    maintainers = with lib.maintainers; [ wyvie ];
    platforms = [ "i386-linux" "x86_64-darwin" "x86_64-linux" ];
  };
})
