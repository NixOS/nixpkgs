{ lib
, stdenvNoCC
, fetchzip
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook
, gobject-introspection
, gdk-pixbuf
, jre
, android-tools
}:

stdenvNoCC.mkDerivation rec {
  pname = "agi";
<<<<<<< HEAD
  version = "3.3.1";

  src = fetchzip {
    url = "https://github.com/google/agi/releases/download/${version}/agi-${version}-linux.zip";
    sha256 = "sha256-Yawl6InBYSWNw3clHyGAeC2PVfXEzWmbd6vcYrqAPO0=";
=======
  version = "3.3.0";

  src = fetchzip {
    url = "https://github.com/google/agi/releases/download/v${version}/agi-${version}-linux.zip";
    sha256 = "sha256-vKq1pe4Z0blSvNgez+/MP2rA0+QfCyr3RsCGX4GMR08=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gdk-pixbuf
    gobject-introspection
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./{agi,gapis,gapir,gapit,device-info} $out/bin
    cp -r lib $out

    for i in 16 32 48 64 96 128 256 512 1024; do
      install -D ${src}/icon.png $out/share/icons/hicolor/''${i}x$i/apps/agi.png
    done

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    wrapProgram $out/bin/agi \
      --add-flags "--vm ${jre}/bin/java" \
      --add-flags "--adb ${android-tools}/bin/adb" \
      --add-flags "--jar $out/lib/gapic.jar" \
      "''${gappsWrapperArgs[@]-}"
  '';

  desktopItems = lib.toList (makeDesktopItem {
    name = "agi";
    desktopName = "Android GPU Inspector";
    exec = "agi";
    icon = "agi";
    categories = [ "Development" "Debugger" "Graphics" "3DGraphics" ];
  });

  meta = with lib; {
    description = "Android GPU Inspector";
    homepage = "https://gpuinspector.dev";
    changelog = "https://github.com/google/agi/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ivar kashw2 ];
=======
    maintainers = [ maintainers.ivar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };
}
