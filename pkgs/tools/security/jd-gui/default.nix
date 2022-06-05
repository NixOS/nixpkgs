{ lib, stdenv, fetchFromGitHub, jre, jdk, gradle_5, makeDesktopItem, copyDesktopItems, perl, writeText, runtimeShell }:

let
  pname = "jd-gui";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "java-decompiler";
    repo = pname;
    rev = "v${version}";
    sha256 = "010bd3q2m4jy4qz5ahdx86b5f558s068gbjlbpdhq3bhh4yrjy20";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk perl gradle_5 ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon jar
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
    outputHash = "1qil12s0daxpxj5xj5dj6s2k89is0kiir2vcafkm3lasc41acmk3";
  };

  # Point to our local deps repo
  gradleInit = writeText "init.gradle" ''
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
    name = "jd-gui";
    exec = "jd-gui %F";
    icon = "jd-gui";
    comment = "Java Decompiler JD-GUI";
    desktopName = "JD-GUI";
    genericName = "Java Decompiler";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" "Debugger" ];
    startupWMClass = "org-jd-gui-App";
  };

in stdenv.mkDerivation rec {
  inherit pname version src;
  name = "${pname}-${version}";

  nativeBuildInputs = [ jdk gradle_5 copyDesktopItems ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --info --init-script ${gradleInit} jar
  '';

  installPhase = let
    jar = "$out/share/jd-gui/${name}.jar";
  in ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{jd-gui,icons/hicolor/128x128/apps}
    cp build/libs/${name}.jar ${jar}
    cp src/linux/resources/jd_icon_128.png $out/share/icons/hicolor/128x128/apps/jd-gui.png

    cat > $out/bin/jd-gui <<EOF
    #!${runtimeShell}
    export JAVA_HOME=${jre}
    exec ${jre}/bin/java -jar ${jar} "\$@"
    EOF
    chmod +x $out/bin/jd-gui

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Fast Java Decompiler with powerful GUI";
    homepage    = "https://java-decompiler.github.io/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
