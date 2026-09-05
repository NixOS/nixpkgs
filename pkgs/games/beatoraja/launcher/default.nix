{
  lib,
  stdenvNoCC,
  replaceVars,
  jre,
  openal,
  jportaudio,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
}:

stdenvNoCC.mkDerivation {
  pname = "beatoraja-launcher";
  version = "0.0.1";

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isDarwin desktopToDarwinBundle;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${
      let
        ldVar = if stdenvNoCC.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
      in
      replaceVars ./launcher.sh {
        ldEnv = "${ldVar}=${
          lib.makeLibraryPath [
            openal
            jportaudio
          ]
        }:$${ldVar}";
        java = lib.getExe jre;
      }
    } $out/bin/beatoraja

    # vendor a simple logo because the beatoraja upstream does not have one
    install -Dm644 ${./logo.svg} $out/share/icons/hicolor/scalable/apps/beatoraja.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "beatoraja";
      comment = "BMS player";
      desktopName = "beatoraja";
      exec = "beatoraja %U";
      icon = "beatoraja";
      startupWMClass = "bms.player.beatoraja.MainLoader";
      categories = [ "Game" ];
    })
  ];

  meta = {
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
    mainProgram = "beatoraja";
  };
}
