{ lib
, stdenv
, fetchgit
, openjdk17_headless
, gradle_7
, perl
, makeWrapper
}:
let
  gradle = gradle_7;
in
stdenv.mkDerivation rec {
  pname = "apksigner";
  version = "33.0.1";

  src = fetchgit {
    # use pname here because the final jar uses this as the filename
    name = pname;
    url = "https://android.googlesource.com/platform/tools/apksig";
    rev = "platform-tools-${version}";
    hash = "sha256-CKvwB9Bb12QvkL/HBOwT6DhA1PI45+QnTNfwnvReGUQ=";
  };

  postPatch = ''
    cat >> build.gradle <<EOF

    apply plugin: 'application'
    mainClassName = "com.android.apksigner.ApkSignerTool"
    sourceSets.main.java.srcDirs = [ 'src/apksigner/java', 'src/main/java' ]
    jar {
        manifest { attributes "Main-Class": "com.android.apksigner.ApkSignerTool" }
        from { (configurations.runtimeClasspath).collect { it.isDirectory() ? it : zipTree(it) } } {
            exclude 'META-INF/*.RSA', 'META-INF/*.SF', 'META-INF/*.DSA', 'META-INF/native/*.dll'
        }
        from('src/apksigner/java') {
            include 'com/android/apksigner/*.txt'
        }
    }
    EOF
    sed -i -e '/conscrypt/s/testImplementation/implementation/' build.gradle
  '';

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version postPatch;
    nativeBuildInputs = [ gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/okio-jvm/okio/r)}" #e' \
        | sh
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashMode = "recursive";
    # Downloaded jars differ by platform
    outputHash = "sha256-cs95YI0SpvzCo5x5trMXlVUGepNKIH9oZ95AfLErKIU=";
  };

  preBuild = ''
    # Use the local packages from -deps
    sed -i -e '/repositories {/a maven { url uri("${deps}") }' build.gradle
  '';

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon build

    runHook postBuild
  '';

  nativeBuildInputs = [ gradle makeWrapper ];

  installPhase = ''
    install -Dm444 build/libs/apksigner.jar -t $out/lib
    makeWrapper "${openjdk17_headless}/bin/java" "$out/bin/apksigner" \
      --add-flags "-jar $out/lib/apksigner.jar"
  '';

  meta = with lib; {
    description = "Command line tool to sign and verify Android APKs";
    homepage = "https://developer.android.com/studio/command-line/apksigner";
    license = licenses.asl20;
    maintainers = with maintainers; [ linsui ];
    platforms = platforms.unix;
  };
}
