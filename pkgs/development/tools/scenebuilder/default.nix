<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, jdk11, gradle_6, makeDesktopItem, copyDesktopItems, perl, writeText, runtimeShell, makeWrapper, glib, wrapGAppsHook }:
let
  gradle = gradle_6;

  pname = "scenebuilder";
  version = "15.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gluonhq";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Og+dzkJ6+YH0fD4HJw8gUKGgvQuNw17BxgzZMP/bEA0=";
  };

  buildDate = "2022-10-07T00:00:00+01:00"; # v20.0.0 release date
  mvnParameters = "-Dmaven.test.skip -Dproject.build.outputTimestamp=${buildDate} -DbuildTimestamp=${buildDate}";
  mvnHash = selectSystem {
    x86_64-linux = "sha256-3SFCQ+hyQPtAEx1jSbe/Qtq4dYkfVvU/Kmekzv53o3U=";
    aarch64-linux = "sha256-AZ1NXzSRyT77W+EjLIb7eWxf7Ztu6XuKjSImRg1lNcw=";
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
=======
    sha256 = "0dqlpfgr9qpmk62zsnhzw4q6n0swjqy00294q0kb4djp3jn47iz4";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk11 perl gradle ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon build -x test
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "01dkayad68g3zpzdnjwrc0h6s7s6n619y5b576snc35l8g2r5sgd";
  };

  # Point to our local deps repo
  gradleInit = writeText "init.gradle" ''
    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
    logger.lifecycle 'Replacing Maven repositories with ${deps}...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${deps}' }
          }
        }
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
  '';

  desktopItem = makeDesktopItem {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    name = "scenebuilder";
    exec = "scenebuilder";
    icon = "scenebuilder";
    comment = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    desktopName = "Scene Builder";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" ];
<<<<<<< HEAD
  }) ];
=======
  };

in stdenv.mkDerivation rec {
  inherit pname src version;

  nativeBuildInputs = [ jdk11 gradle makeWrapper glib wrapGAppsHook ];

  dontWrapGApps = true; # prevent double wrapping

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle -PVERSION=${version} --offline --no-daemon --info --init-script ${gradleInit} build -x test

    runHook postBuild
    '';

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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
