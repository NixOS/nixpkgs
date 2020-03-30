{ stdenv, fetchFromGitLab, gradle_5, jre, perl, writeText, runtimeShell }:

let
  pname = "pdftk";
  version = "3.0.8";

  src = fetchFromGitLab {
    owner = "pdftk-java";
    repo = "pdftk";
    rev = "v${version}";
    sha256 = "1bj4a9g5mbxd859mmawzs0mpm0jw7ap4n1imcwkwz142r9x1g6rk";
  };

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;

    nativeBuildInputs = [ gradle_5 perl ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle -Dfile.encoding=utf-8 shadowJar;
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
    outputHash = "12b7lw1zpj69pv4bpbrm6pi0ip02ay3dfj3vcy2jyikfbwdb3qcz";
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

    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${deps}' }
        }
      }
  }
  '';

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ gradle_5 ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --info --init-script ${gradleInit} shadowJar
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/pdftk,share/man/man1}
    cp build/libs/pdftk.jar $out/share/pdftk

    cat  << EOF > $out/bin/pdftk
    #!${runtimeShell}
    exec ${jre}/bin/java -jar "$out/share/pdftk/pdftk.jar" "\$@"
    EOF
    chmod a+x "$out/bin/pdftk"

    cp ${src}/pdftk.1 $out/share/man/man1
  '';

  meta = {
    description = "Command-line tool for working with PDFs";
    homepage = "https://gitlab.com/pdftk-java/pdftk";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ raskin averelld ];
    platforms = stdenv.lib.platforms.unix;
  };
}
