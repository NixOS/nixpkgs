{ lib
, stdenv
, fetchurl
, makeBinaryWrapper
, makeDesktopItem
, wrapGAppsHook
, copyDesktopItems
, imagemagick
, jre
, xorg
, libGL
, glfw
, openal
, libglvnd
, alsa-lib
, wayland
, libpulseaudio
}:

let
  version = "3.5.5";
  icon = fetchurl {
    url = "https://github.com/huanghongxun/HMCL/raw/release-${version}/HMCLauncher/HMCL/HMCL.ico";
    hash = "sha256-MWp78rP4b39Scz5/gpsjwaJhSu+K9q3S2B2cD/V31MA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hmcl";
  inherit version;

  src = fetchurl {
    url = "https://github.com/huanghongxun/HMCL/releases/download/release-${version}/HMCL-${version}.jar";
    hash = "sha256-bXZF38pd8I8cReuDNrZzDj1hp1Crk+P26JNiikUCg4g=";
  };

  dontUnpack = true;

  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "HMCL";
      exec = "hmcl";
      icon = "hmcl";
      comment = finalAttrs.meta.description;
      desktopName = "HMCL";
      categories = [ "Game" ];
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    wrapGAppsHook
    copyDesktopItems
    imagemagick
  ];

  installPhase =
    let
      libpath = lib.makeLibraryPath ([
        libGL
        glfw
        openal
        libglvnd
      ] ++ lib.optionals stdenv.isLinux [
        xorg.libX11
        xorg.libXxf86vm
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXtst
        libpulseaudio
        wayland
        alsa-lib
      ]);
    in
    ''
      runHook preInstall
      mkdir -p $out/{bin,lib/hmcl}
      cp $src $out/lib/hmcl/hmcl.jar
      magick ${icon} hmcl.png
      install -Dm644 hmcl.png $out/share/icons/hicolor/32x32/apps/hmcl.png
      makeBinaryWrapper ${jre}/bin/java $out/bin/hmcl \
        --add-flags "-jar $out/lib/hmcl/hmcl.jar" \
        --set LD_LIBRARY_PATH ${libpath}
      runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://hmcl.huangyuhui.net";
    description = "A Minecraft Launcher which is multi-functional, cross-platform and popular";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    inherit (jre.meta) platforms;
  };
})
