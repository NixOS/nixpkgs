{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  alsa-lib,
  dbus,
  gtk3,
  hidapi,
  libGL,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxxf86vm,
  udev,
  vulkan-loader,
  wayland,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ultrastar-play";
  version = "1.5.1-beta6";
  src =
    if stdenv.hostPlatform.isLinux then
      fetchzip {
        url = "https://github.com/UltraStar-Deluxe/Play/releases/download/v${finalAttrs.version}/StandaloneLinux64-build.zip";
        stripRoot = false;
        hash = "sha256-VAvnki4xq2NYkEj2FKuI1+nNYKsOCG4xzMSBhOxgXmU=";
      }
    else if stdenv.hostPlatform.isDarwin then
      fetchzip {
        url = "https://github.com/UltraStar-Deluxe/Play/releases/download/v${finalAttrs.version}/StandaloneOSX-build.zip";
        stripRoot = false;
        hash = "sha256-a0f74scv3nJetWnjHukFyt82a3EZPxw8CqpF98PEfNo=";
      }
    else
      throw "Unsupported platform: ${stdenv.hostPlatform.system}";

  dontBuild = true; # pre-built binary, sooo no build step
  dontStrip = true; # Unity data files would crash strip
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
    gtk3
    hidapi
    libGL
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxxf86vm
    udev
    vulkan-loader
    wayland
    (lib.getLib stdenv.cc.cc)
    zlib
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "ultrastar-play";
      exec = "ultrastar-play";
      icon = "ultrastar-play";
      desktopName = "UltraStar Play";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
        "Audio"
        "Music"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''

    mkdir -p "$out/libexec/ultrastar-play"
    install -Dm755 "StandaloneLinux64" "$out/libexec/ultrastar-play/StandaloneLinux64"
    install -Dm644 "UnityPlayer.so" "$out/libexec/ultrastar-play/UnityPlayer.so"
    cp -r "StandaloneLinux64_Data" "$out/libexec/ultrastar-play/"

    install -Dm644 "StandaloneLinux64_Data/Resources/UnityPlayer.png" \
      "$out/share/icons/hicolor/128x128/apps/ultrastar-play.png"

    makeWrapper "$out/libexec/ultrastar-play/StandaloneLinux64" "$out/bin/ultrastar-play"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r "StandaloneOSX.app" "$out/Applications/UltraStar Play.app"

    makeWrapper "$out/Applications/UltraStar Play.app/Contents/MacOS/UltraStar Play" \
      "$out/bin/ultrastar-play"
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    # UnityPlayer.so dlopen()s these at runtime but they aren't in DT_NEEDED,
    # so autoPatchelfHook cannot find them.
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libGL.so.1 \
      --add-needed libhidapi-hidraw.so.0 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      "$out/libexec/ultrastar-play/UnityPlayer.so"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free and open source singing game with song editor for desktop and mobile";
    longDescription = ''
      UltraStar Play is a free and open source singing game.
      The game plays an audio file, displays lyrics, notes, and optionally a
      background video or image, while the players sing along to earn points.
      It supports solos, duets, group play, and includes an integrated song editor.
    '';
    homepage = "https://usplay.net/";
    changelog = "https://github.com/UltraStar-Deluxe/Play/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "ultrastar-play";
  };
})
