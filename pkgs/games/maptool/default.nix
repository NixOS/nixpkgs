{ lib
, copyDesktopItems
, fetchurl
, ffmpeg
, gitUpdater
, jre
, libarchive
, makeDesktopItem
, openjfx
, stdenvNoCC
, wrapGAppsHook
}:
let
  pname = "maptool";
  version = "1.13.1";
  repoBase = "https://github.com/RPTools/${pname}";
  src = fetchurl {
    url = "${repoBase}/releases/download/${version}/MapTool-${version}.jar";
    hash = "sha256-EHisFvLaqi8VqIdygf0nxohKLL3c/yE5Y6jAcT0B2q0=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/RPTools/${pname}/${version}/package/linux/MapTool.png";
    hash = "sha256-xkVYjMprTanHu8r4b9PHORI8E1aJp+9KDSP5mqCE8ew=";
  };

  meta = with lib; {
    description = "Virtual Tabletop for playing roleplaying games with remote players or face to face";
    homepage = "https://www.rptools.net/toolbox/maptool/";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.agpl3;
    maintainers = with maintainers; [ rhendric ];
  };

  javafxModules = [ "base" "controls" "media" "swing" "web" "fxml" "graphics" ];

  classpath =
    lib.concatMap (mod: [
      "${openjfx}/modules_src/javafx.${mod}/module-info.java"
      "${openjfx}/modules/javafx.${mod}"
      "${openjfx}/modules_libs/javafx.${mod}"
    ]) javafxModules ++
    [ src ];

  jvmArgs = [
    "-cp" (lib.concatStringsSep ":" classpath)
    "-Xss8M"
    "-Dsun.java2d.d3d=false"
    "-Dfile.encoding=UTF-8"
    "-Dpolyglot.engine.WarnInterpreterOnly=false"
    "-XX:+ShowCodeDetailsInExceptionMessages"
    "--add-opens=java.desktop/java.awt=ALL-UNNAMED"
    "--add-opens=java.desktop/java.awt.geom=ALL-UNNAMED"
    "--add-opens=java.desktop/sun.awt.geom=ALL-UNNAMED"
    "--add-opens=java.base/java.util=ALL-UNNAMED"
    "--add-opens=javafx.web/javafx.scene.web=ALL-UNNAMED"
    "--add-opens=javafx.web/com.sun.webkit=ALL-UNNAMED"
    "--add-opens=javafx.web/com.sun.webkit.dom=ALL-UNNAMED"
    "--add-opens=java.desktop/javax.swing=ALL-UNNAMED"
    "--add-opens=java.desktop/sun.awt.shell=ALL-UNNAMED"
    "--add-opens=java.desktop/com.sun.java.swing.plaf.windows=ALL-UNNAMED"

    # disable telemetry (the empty DSN disables the Sentry library, setting the
    # environment to Development disables some logic inside MapTool)
    "-Dsentry.dsn"
    "-Dsentry.environment=Development"
  ];

  binName = pname;
  rdnsName = "net.rptools.maptool";
in
stdenvNoCC.mkDerivation {
  inherit pname version src meta;

  dontUnpack = true;
  dontBuild = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    copyDesktopItems
    libarchive
    wrapGAppsHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = rdnsName;
      desktopName = "MapTool";
      icon = rdnsName;
      exec = binName;
      comment = meta.description;
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${binName} \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ ffmpeg ]} \
      --add-flags '${lib.concatStringsSep " " jvmArgs} net.rptools.maptool.client.LaunchInstructions'

    dest=$out/share/icons/hicolor/256x256/apps
    mkdir -p "$dest"
    ln -s ${icon} "$dest/${rdnsName}.png"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "${repoBase}.git";
    ignoredVersions = "-";
  };
}
