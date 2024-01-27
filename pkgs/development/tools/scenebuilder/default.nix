{ lib, stdenv, fetchFromGitHub, openjdk20, maven, makeDesktopItem, copyDesktopItems, makeWrapper, glib, wrapGAppsHook }:

let
  jdk = openjdk20.override (lib.optionalAttrs stdenv.isLinux {
    enableJavaFX = true;
  });
  maven' = maven.override {
    inherit jdk;
  };
  selectSystem = attrs:
    attrs.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
maven'.buildMavenPackage rec {
  pname = "scenebuilder";
  version = "20.0.0";

  src = fetchFromGitHub {
    owner = "gluonhq";
    repo = pname;
    rev = version;
    hash = "sha256-Og+dzkJ6+YH0fD4HJw8gUKGgvQuNw17BxgzZMP/bEA0=";
  };

  buildDate = "2022-10-07T00:00:00+01:00"; # v20.0.0 release date
  mvnParameters = "-Dmaven.test.skip -Dproject.build.outputTimestamp=${buildDate} -DbuildTimestamp=${buildDate}";
  mvnHash = selectSystem {
    x86_64-linux = "sha256-QwxA3lKVkRG5CV2GIwfVFPOj112pHr7bDlZJD6KwrHc=";
    aarch64-linux = "sha256-cO5nHSvv2saBuAjq47A+GW9vFWEM+ysXyZgI0Oe/F70=";
  };

  nativeBuildInputs = [ copyDesktopItems makeWrapper glib wrapGAppsHook ];

  dontWrapGApps = true; # prevent double wrapping

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java $out/share/{${pname},icons/hicolor/128x128/apps}
    cp app/target/lib/scenebuilder-${version}-SNAPSHOT-all.jar $out/share/java/${pname}.jar

    cp app/src/main/resources/com/oracle/javafx/scenebuilder/app/SB_Logo.png $out/share/icons/hicolor/128x128/apps/scenebuilder.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
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

