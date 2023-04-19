{ lib, stdenv, fetchFromGitHub, jdk, gradle_7, makeDesktopItem, copyDesktopItems, perl, writeText, runtimeShell, makeWrapper }:
let
  pname = "scenic-view";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "JonathanGiles";
    repo = pname;
    rev = version;
    sha256 = "1idfh9hxqs4fchr6gvhblhvjqk4mpl4rnpi84vn1l3yb700z7dwy";
  };

  gradle = gradle_7;

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk perl gradle ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon build
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo =  "sha256";
    outputHashMode = "recursive";
    outputHash = "0d6qs0wg2nfxyq85q46a8dcdqknz9pypb2qmvc8k2w8vcdac1y7n";
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
    name = pname;
    desktopName = pname;
    exec = pname;
    comment = "JavaFx application to visualize and modify the scenegraph of running JavaFx applications.";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" ];
  };

in stdenv.mkDerivation rec {
  inherit pname version src;
  nativeBuildInputs = [ jdk gradle makeWrapper ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --info --init-script ${gradleInit} build

    runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    cp build/libs/scenicview.jar $out/share/${pname}/${pname}.jar
    makeWrapper ${jdk}/bin/java $out/bin/${pname} --add-flags "-jar $out/share/${pname}/${pname}.jar"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "JavaFx application to visualize and modify the scenegraph of running JavaFx applications.";
    longDescription = ''
      A JavaFX application designed to make it simple to understand the current state of your application scenegraph
      and to also easily manipulate properties of the scenegraph without having to keep editing your code.
      This lets you find bugs and get things pixel perfect without having to do the compile-check-compile dance.
    '';
    homepage = "https://github.com/JonathanGiles/scenic-view/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wirew0rm ];
    platforms = platforms.all;
  };
}
