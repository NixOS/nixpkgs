{ lib, stdenv, fetchFromGitHub, jdk11, gradle_6, makeDesktopItem, makeWrapper, glib, wrapGAppsHook }:
let
  gradle = gradle_6;

  pname = "scenebuilder";
  version = "15.0.1";

  src = fetchFromGitHub {
    owner = "gluonhq";
    repo = pname;
    rev = version;
    sha256 = "0dqlpfgr9qpmk62zsnhzw4q6n0swjqy00294q0kb4djp3jn47iz4";
  };

  desktopItem = makeDesktopItem {
    name = "scenebuilder";
    exec = "scenebuilder";
    icon = "scenebuilder";
    comment = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    desktopName = "Scene Builder";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" ];
  };

in gradle.buildPackage rec {
  inherit pname src version;

  nativeBuildInputs = [ jdk11 makeWrapper glib wrapGAppsHook ];

  dontWrapGApps = true; # prevent double wrapping

  gradleOpts = {
    depsHash = "sha256-p9pU1BvQJsFhcbXTqePDe4OYMxuMDO6sImrIXrAH5qk=";
    lockfileTree = ./lockfiles;
    flags = [ "-PVERSION=${version}" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{${pname},icons/hicolor/128x128/apps}
    cp app/build/libs/SceneBuilder-${version}-all.jar $out/share/${pname}/${pname}.jar
    cp app/build/resources/main/com/oracle/javafx/scenebuilder/app/SB_Logo.png $out/share/icons/hicolor/128x128/apps/scenebuilder.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jdk11}/bin/java $out/bin/${pname} --add-flags "-jar $out/share/${pname}/${pname}.jar" "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [ desktopItem ];

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
