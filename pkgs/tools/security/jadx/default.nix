{ stdenv, fetchFromGitHub, gradle, jdk, makeWrapper, perl }:

let
  pname = "jadx";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "skylot";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dx3g0sm46qy57gggpg8bpmin5glzbxdbf0qzvha9r2dwh4mrwlg";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ gradle jdk perl ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      export JADX_VERSION=${version}
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
    outputHash = "083r4hg6m9cxzm2m8nckf10awq8kh901v5i39r60x47xk5yw84ps";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ gradle jdk makeWrapper ];

  buildPhase = ''
    # The installDist Gradle build phase tries to copy some dependency .jar
    # files multiple times into the build directory. This ends up failing when
    # the dependencies are read directly from the Nix store since they are not
    # marked as chmod +w. To work around this, get a local copy of the
    # dependency store, and give write permissions.
    depsDir=$(mktemp -d)
    cp -R ${deps}/* $depsDir
    chmod -R u+w $depsDir

    gradleInit=$(mktemp)
    cat >$gradleInit <<EOF
      gradle.projectsLoaded {
        rootProject.allprojects {
          buildscript {
            repositories {
              clear()
              maven { url '$depsDir' }
            }
          }
          repositories {
            clear()
            maven { url '$depsDir' }
          }
        }
      }

      settingsEvaluated { settings ->
        settings.pluginManagement {
          repositories {
            maven { url '$depsDir' }
          }
        }
      }
    EOF

    export GRADLE_USER_HOME=$(mktemp -d)
    export JADX_VERSION=${version}
    gradle --offline --no-daemon --info --init-script $gradleInit pack
  '';

  installPhase = ''
    mkdir $out $out/bin
    cp -R build/jadx/lib $out
    for prog in jadx jadx-gui; do
      cp build/jadx/bin/$prog $out/bin
      wrapProgram $out/bin/$prog --set JAVA_HOME ${jdk.home}
    done
  '';

  meta = with stdenv.lib; {
    description = "Dex to Java decompiler";
    longDescription = ''
      Command line and GUI tools for produce Java source code from Android Dex
      and Apk files.
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ delroth ];
  };
}
