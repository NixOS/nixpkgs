{ stdenv, fetchurl, gradle_2_5, perl, makeWrapper, jre, makeDesktopItem, writeText }:

let
  version = "1.4.0";
  name = "jd-gui-${version}";

  src = fetchurl {
    url    = "https://github.com/java-decompiler/jd-gui/archive/v${version}.tar.gz";
    sha256 = "0anz7szlr5kgmsmkyv34jdynsnk8v6kvibcyz98jsd96fh725lax";
  };

  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src;
    nativeBuildInputs = [ gradle_2_5 perl ];

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

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1apmqiphnav79m4rdii58h7f4qslpfig4qybyyl2fr7zk92gv3l9";
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
    mimeType = "application/x-java-archive;application/x-java";
    categories = "Development;Debugger;";
  };

in stdenv.mkDerivation rec {
  inherit name version src;

  nativeBuildInputs = [ gradle_2_5 perl makeWrapper ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --info --init-script ${gradleInit} jar
  '';

  installPhase = let
    jar = "$out/share/jd-gui/${name}.jar";
  in ''
    mkdir -p $out/bin $out/share/{jd-gui,icons/hicolor/128x128/apps}
    cp build/libs/${name}.jar ${jar}
    cp src/linux/resources/jd_icon_128.png $out/share/icons/hicolor/128x128/apps/jd-gui.png

    cat > $out/bin/jd-gui <<EOF
    #!${stdenv.shell}
    export JAVA_HOME=${jre}
    ${jre}/bin/java -jar ${jar} $@
    EOF
    chmod +x $out/bin/jd-gui

    ${(desktopItem "$out/bin/jd-gui").buildCommand}
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Fast Java Decompiler with powerful GUI";
    homepage    = "http://jd.benow.ca/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
