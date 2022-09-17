{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk11,
  gradle,
  makeWrapper,
  glib,
  perl,
  writeText
}:

let
  pname = "aeron";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = pname;
    rev = version;
    sha256 = "sha256-4C5YofA/wxwa7bfc6IqsDrw8CLQWKoVBCIe8Ec7ifAg=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [
      gradle
      jdk11
      perl
    ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle \
          --no-daemon \
        build \
          -Dorg.gradle.java.home="${jdk11.home}" \
          -x test \
          -x checkstyleMain \
          -x checkstyleGenerated \
          -x checkstyleGeneratedTest \
          -x checkstyleMain \
          -x checkstyleTest
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find "$GRADLE_USER_HOME/caches/modules-2" -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      ln -s "$out/com/squareup/okio/okio/2.10.0/okio-jvm-2.10.0.jar" "$out/com/squareup/okio/okio/2.10.0/okio-2.10.0.jar"
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-QRL3y7HF6/pWsC5MbtIqhZ4HR8jcWtQG6x9kajeoNMY=";
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
    gradle.projectsLoaded {
      rootProject.allprojects {
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
  '';

  # replace buildSrc
  buildSrc = writeText "build.gradle" ''
    repositories {
      clear()
      maven { url '${deps}' }
    }

    dependencies {
      implementation 'org.asciidoctor:asciidoctorj:2.5.5'
      implementation 'org.eclipse.jgit:org.eclipse.jgit:5.13.1.202206130422-r'
    }
  '';

in stdenv.mkDerivation rec {

  inherit pname src version;

  nativeBuildInputs = [
    glib
    gradle
    jdk11
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    cp ${buildSrc} ./buildSrc/build.gradle

    gradle -PVERSION=${version} \
        --offline \
        --no-daemon \
        --init-script "${gradleInit}" \
      build \
        -Dorg.gradle.java.home="${jdk11.home}" \
        -x test \
        -x checkstyleMain \
        -x checkstyleGenerated \
        -x checkstyleGeneratedTest \
        -x checkstyleMain \
        -x checkstyleTest

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D --mode=0444 --target-directory="$out/share/java" \
      "./aeron-all/build/libs/aeron-all-${version}.jar" \
      "./aeron-agent/build/libs/aeron-agent-${version}.jar" \
      "./aeron-archive/build/libs/aeron-archive-${version}.jar" \
      "./aeron-client/build/libs/aeron-client-${version}.jar"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "${jdk11}/bin/java" "$out/bin/${pname}-stat" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/aeron-all-${version}.jar io.aeron.samples.AeronStat"

    makeWrapper "${jdk11}/bin/java" "$out/bin/${pname}-archiving-media-driver" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/aeron-all-${version}.jar io.aeron.archive.ArchivingMediaDriver"

    makeWrapper "${jdk11}/bin/java" "$out/bin/${pname}-archive-tool" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/aeron-all-${version}.jar io.aeron.archive.ArchiveTool"

    makeWrapper "${jdk11}/bin/java" "$out/bin/${pname}-logging-agent" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/aeron-all-${version}.jar io.aeron.agent.DynamicLoggingAgent"

    makeWrapper "${jdk11}/bin/java" "$out/bin/${pname}-cluster-tool" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/aeron-all-${version}.jar io.aeron.cluster.ClusterTool"
  '';

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.vaci ];
  };
}
