{ lib, stdenv, fetchFromGitHub, jre, maven, makeDesktopItem, copyDesktopItems, perl, writeText, runtimeShell, makeWrapper, glib, wrapGAppsHook }:
maven.buildMavenPackage rec {
  pname = "scenebuilder";
  version = "19.0.0"; # 20.0.0 already available but needs java20 which is not available in nixpkgs yet

  src = fetchFromGitHub {
    owner = "gluonhq";
    repo = pname;
    rev = version;
    hash = "sha256-No0yMAVmM5T++h74ZZIufaHmJBOzYhI0EtfOEGWGzis=";
  };

  inherit jre;

  buildDate = "2022-10-07T00:00:00+01:00"; # v20.0.0 release date
  mvnParameters = "-Dmaven.test.skip -Dproject.build.outputTimestamp=${buildDate} -DbuildTimestamp=${buildDate}";
  mvnHash = "sha256-G4WjQVRawNITSGh/e+fb6fVe80WSd0swT3uPIQOlif4=";

  nativeBuildInputs = [ copyDesktopItems maven makeWrapper glib wrapGAppsHook ];

  dontWrapGApps = true; # prevent double wrapping

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java $out/share/{${pname},icons/hicolor/128x128/apps}
    cp app/target/lib/scenebuilder-${version}-SNAPSHOT-all.jar $out/share/java/${pname}.jar

    cp app/src/main/resources/com/oracle/javafx/scenebuilder/app/SB_Logo.png $out/share/icons/hicolor/128x128/apps/scenebuilder.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "--add-modules javafx.web,javafx.fxml,javafx.swing,javafx.media" \
      --add-flags "--add-opens=javafx.fxml/javafx.fxml=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/${pname}.jar" \
      --add-flags "com.oracle.javafx.scenebuilder.app.SceneBuilderApp" \
      "''${gappsWrapperArgs[@]}"
    '';

  desktopItems = [ (makeDesktopItem {
    name = "scenebuilder";
    exec = "scenebuilder";
    icon = "scenebuilder";
    comment = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    desktopName = "Scene Builder";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" ];
  }) ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    homepage = "https://gluonhq.com/products/scene-builder/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.bsd3;
    maintainers = with maintainers; [ wirew0rm ];
    platforms = platforms.all;
  };
}

