{ lib
, jdk21
, maven
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, glib
, makeWrapper
, wrapGAppsHook3
}:

let
  jdk = jdk21.override {
    enableJavaFX = true;
  };
  maven' = maven.override {
    inherit jdk;
  };
in
maven'.buildMavenPackage rec {
  pname = "scenebuilder";
  version = "21.0.1";

  src = fetchFromGitHub {
    owner = "gluonhq";
    repo = "scenebuilder";
    rev = version;
    hash = "sha256-YEcW1yQK6RKDqSstsrpdOqMt972ZagenGDxcJ/gP+SA=";
  };

  patches = [
    # makes the mvnHash platform-independent
    ./pom-remove-javafx.patch

    # makes sure that maven upgrades don't change the mvnHash
    ./fix-default-maven-plugin-versions.patch
  ];

  postPatch = ''
    # set the build timestamp to $SOURCE_DATE_EPOCH
    substituteInPlace app/pom.xml \
        --replace-fail "\''${maven.build.timestamp}" "$(date -d "@$SOURCE_DATE_EPOCH" '+%Y-%m-%d %H:%M:%S')"
  '';

  mvnParameters = toString [
    "-Dmaven.test.skip"
    "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z"
  ];

  mvnHash = "sha256-fS7dS2Q4ORThLBwDOzJJnRboNNRmhp0RG6Dae9fl+pw=";

  nativeBuildInputs = [
    copyDesktopItems
    glib
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true; # prevent double wrapping

  installPhase = ''
    runHook preInstall

    install -Dm644 app/target/lib/scenebuilder-${version}-SNAPSHOT-all.jar $out/share/scenebuilder/scenebuilder.jar
    install -Dm644 app/src/main/resources/com/oracle/javafx/scenebuilder/app/SB_Logo.png $out/share/icons/hicolor/128x128/apps/scenebuilder.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jdk}/bin/java $out/bin/scenebuilder \
      --add-flags "--add-modules javafx.web,javafx.fxml,javafx.swing,javafx.media" \
      --add-flags "--add-opens=javafx.fxml/javafx.fxml=ALL-UNNAMED" \
      --add-flags "-jar $out/share/scenebuilder/scenebuilder.jar" \
      "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "scenebuilder";
      exec = "scenebuilder";
      icon = "scenebuilder";
      comment = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
      desktopName = "Scene Builder";
      mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
      categories = [ "Development" ];
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/gluonhq/scenebuilder/releases/tag/${src.rev}";
    description = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    homepage = "https://gluonhq.com/products/scene-builder/";
    license = licenses.bsd3;
    mainProgram = "scenebuilder";
    maintainers = with maintainers; [ wirew0rm ];
    platforms = jdk.meta.platforms;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
}

