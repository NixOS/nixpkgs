{ lib
, fetchgit
, openjdk17_headless
, gradle_7
, makeWrapper
}:
let
  gradle = gradle_7;
in
gradle.buildPackage rec {
  pname = "apksigner";
  version = "33.0.1";

  gradleOpts.depsHash = "sha256-LB5gSK7CSU/qTMWFaB6N9fDRkhuE9SFXuIcc/xDIeEw=";
  gradleOpts.lockfile = ./gradle.lockfile;
  gradleOpts.buildscriptLockfile = ./buildscript-gradle.lockfile;

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

  nativeBuildInputs = [ makeWrapper ];

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
