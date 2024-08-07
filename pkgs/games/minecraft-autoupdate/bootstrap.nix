{ lib
, stdenv
, fetchurl
, desktopItem
, copyDesktopItems
, makeWrapper
, wrapGAppsHook
, gobject-introspection
, jre
, libPath
, envLibPath
}:

stdenv.mkDerivation rec {
  pname = "minecraft-launcher";

  # Version of the ado bootstrap launcher
  # The version of the "core" package is separte
  version = "1.2.30";

  src = fetchurl {
    # URL is found by using udpate script
    url = "https://piston-data.mojang.com/v1/objects/bb5d7a5bd5476db2ce04f52b5c7a74ad8db455a7/minecraft-launcher";
    sha256 = "sha256-yUzG4jtVI8JTCze0SmOAuFBGlegUTlVKkfMClr5ywnE=";
  };

  icon = fetchurl {
    url = "https://launcher.mojang.com/download/minecraft-launcher.svg";
    sha256 = "0w8z21ml79kblv20wh5lz037g130pxkgs8ll9s3bi94zn2pbrhim";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook copyDesktopItems gobject-introspection ];

  sourceRoot = ".";

  dontUnpack = true;
  dontWrapGApps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp ${src} $out/opt/minecraft-launcher
    chmod +x $out/opt/minecraft-launcher

    install -D $icon $out/share/icons/hicolor/symbolic/apps/minecraft-launcher.svg

    runHook postInstall
  '';

  preFixup = ''
    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --set-rpath '$ORIGIN/'":${libPath}" \
      $out/opt/minecraft-launcher
  '';

  postFixup = ''
    # Do not create `GPUCache` in current directory
    makeWrapper $out/opt/minecraft-launcher $out/bin/minecraft-launcher \
      --prefix LD_LIBRARY_PATH : ${envLibPath} \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --set JAVA_HOME ${lib.getBin jre} \
      --chdir /tmp \
      "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Official bootstrap launcher for Minecraft, a sandbox-building game";
    homepage = "https://minecraft.net";
    maintainers = with maintainers; [ jonringer ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
