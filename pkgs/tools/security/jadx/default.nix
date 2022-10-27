{ lib, stdenv, fetchFromGitHub, gradle, jdk, makeWrapper, perl }:

let
  pname = "jadx";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "skylot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-so82zzCXIJV5tIVUBJFZEpArThNQVqWASGofNzIobQM=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ gradle jdk perl ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      export JADX_VERSION=${version}
      gradle --no-daemon jar

      # Apparently, Gradle won't cache the `compileOnlyApi` dependency
      # `org.jetbrains:annotations:22.0.0` which is defined in
      # `io.github.skylot:raung-common`. To make it available in the
      # output, we patch `build.gradle` and run Gradle again.
      substituteInPlace build.gradle \
        --replace 'org.jetbrains:annotations:23.0.0' 'org.jetbrains:annotations:22.0.0'
      gradle --no-daemon jar
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      # Work around okio-2.10.0 bug, fixed in 3.0. Remove "-jvm" from filename.
      # https://github.com/square/okio/issues/954
      mv $out/com/squareup/okio/okio/2.10.0/okio{-jvm,}-2.10.0.jar
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-J6YpBYVqx+aWiMFX/67T7bhu4RTlKVaT4t359YJ6m7I=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ gradle jdk makeWrapper ];

  # Otherwise, Gradle fails with `java.net.SocketException: Operation not permitted`
  __darwinAllowLocalNetworking = true;

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

  meta = with lib; {
    description = "Dex to Java decompiler";
    longDescription = ''
      Command line and GUI tools for produce Java source code from Android Dex
      and Apk files.
    '';
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ delroth ];
  };
}
