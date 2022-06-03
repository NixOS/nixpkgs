{ lib, stdenv, fetchFromGitHub, jdk11, gradle_6, makeDesktopItem, copyDesktopItems, perl, writeText, runtimeShell, makeWrapper, glib, wrapGAppsHook }:
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
    name = "scenebuilder";
    exec = "scenebuilder";
    icon = "scenebuilder";
    comment = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    desktopName = "Scene Builder";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" ];
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

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
    homepage = "https://gluonhq.com/products/scene-builder/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wirew0rm ];
    platforms = platforms.all;
  };
}
