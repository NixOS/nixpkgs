{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk11,
  gradle,
  makeWrapper,
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
          --console plain \
          --no-daemon \
          --system-prop org.gradle.java.home="${jdk11.home}" \
          --exclude-task javadoc \
        build
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
    outputHash = "sha256-1hvQyEiCMfIw6wv9GOEehX0wrtBnAilVuTGUWAGoH6k=";
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

  buildInputs = [
    jdk11
  ];

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    cp ${buildSrc} ./buildSrc/build.gradle

    gradle \
        --console plain \
        --exclude-task checkstyleMain \
        --exclude-task checkstyleGenerated \
        --exclude-task checkstyleGeneratedTest \
        --exclude-task checkstyleMain \
        --exclude-task checkstyleTest \
        --exclude-task javadoc \
        --exclude-task test \
        --init-script "${gradleInit}" \
        --no-daemon \
        --offline \
        --project-prop VERSION=${version} \
        --system-prop org.gradle.java.home="${jdk11.home}" \
      assemble

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
    function wrap {
      makeWrapper "${jdk11}/bin/java" "$out/bin/$1" \
        --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
        --add-flags "--class-path $out/share/java/aeron-all-${version}.jar" \
        --add-flags "$2"
    }

    wrap "${pname}-media-driver" io.aeron.driver.MediaDriver
    wrap "${pname}-stat" io.aeron.samples.AeronStat
    wrap "${pname}-archiving-media-driver" io.aeron.archive.ArchivingMediaDriver
    wrap "${pname}-archive-tool" io.aeron.archive.ArchiveTool
    wrap "${pname}-logging-agent" io.aeron.agent.DynamicLoggingAgent
    wrap "${pname}-cluster-tool" io.aeron.cluster.ClusterTool
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    gradle \
        --console plain \
        --init-script "${gradleInit}" \
        --no-daemon \
        --offline \
        --project-prop VERSION=${version} \
        --system-prop org.gradle.java.home="${jdk11.home}" \
      test

    runHook postCheck
  '';

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.vaci ];
  };
}
