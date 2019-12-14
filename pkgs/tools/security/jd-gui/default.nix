{ stdenv, fetchFromGitHub, jre, jdk, makeDesktopItem, perl, writeText, runtimeShell }:

let
  pname = "jd-gui";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "java-decompiler";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yn2xcwznig941pw2f3wi8ixz1wprxcn9wl0g2ggdzx51rfwgzzi";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk perl ];

    patchPhase = "patchShebangs gradlew";

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      ./gradlew --no-daemon jar
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      cp -r $GRADLE_USER_HOME/wrapper $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1s4p91iiyikrsgvpzkhw3jm5lsm0jpzp7iw7afdhhl9jm18igs70";
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

  desktopItem = launcher: makeDesktopItem {
    name = "jd-gui";
    exec = "${launcher} %F";
    icon = "jd-gui";
    comment = "Java Decompiler JD-GUI";
    desktopName = "JD-GUI";
    genericName = "Java Decompiler";
    mimeType = "application/java;application/java-vm;application/java-archive";
    categories = "Development;Debugger;";
    extraEntries="StartupWMClass=org-jd-gui-App";
  };

in stdenv.mkDerivation rec {
  inherit pname version src;
  name = "${pname}-${version}";

  nativeBuildInputs = [ jdk ];

  patchPhase = "patchShebangs gradlew";

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    cp -r ${deps}/wrapper $GRADLE_USER_HOME
    chmod u+w $GRADLE_USER_HOME/wrapper/dists/gradle*/*/*.lck
    ./gradlew --offline --no-daemon --info --init-script ${gradleInit} jar
  '';

  installPhase = let
    jar = "$out/share/jd-gui/${name}.jar";
  in ''
    mkdir -p $out/bin $out/share/{jd-gui,icons/hicolor/128x128/apps}
    cp build/libs/${name}.jar ${jar}
    cp src/linux/resources/jd_icon_128.png $out/share/icons/hicolor/128x128/apps/jd-gui.png

    cat > $out/bin/jd-gui <<EOF
    #!${runtimeShell}
    export JAVA_HOME=${jre}
    exec ${jre}/bin/java -jar ${jar} "\$@"
    EOF
    chmod +x $out/bin/jd-gui

    ${(desktopItem "$out/bin/jd-gui").buildCommand}
  '';

  meta = with stdenv.lib; {
    description = "Fast Java Decompiler with powerful GUI";
    homepage    = "https://java-decompiler.github.io/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
