{ lib, stdenv, fetchurl, unzip, jdk, java ? jdk, makeWrapper }:

let
  gradleSpec = { version, nativeVersion, sha256 }: rec {
    inherit nativeVersion;
    name = "gradle-${version}";
    src = fetchurl {
      inherit sha256;
      url = "https://services.gradle.org/distributions/${name}-bin.zip";
    };
  };
in
rec {
  gradleGen = { name, src, nativeVersion }: stdenv.mkDerivation {
    inherit name src nativeVersion;

    dontBuild = true;

    installPhase = ''
      mkdir -pv $out/lib/gradle/
      cp -rv lib/ $out/lib/gradle/

      gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
      test -f $gradle_launcher_jar
      makeWrapper ${java}/bin/java $out/bin/gradle \
        --set JAVA_HOME ${java} \
        --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain"
    '';

    fixupPhase = if (!stdenv.isLinux) then ":" else
    let arch = if stdenv.is64bit then "amd64" else "i386"; in
    ''
      mkdir patching
      pushd patching
      jar xf $out/lib/gradle/lib/native-platform-linux-${arch}-${nativeVersion}.jar
      patchelf --set-rpath "${stdenv.cc.cc.lib}/lib:${stdenv.cc.cc.lib}/lib64" net/rubygrapefruit/platform/linux-${arch}/libnative-platform.so
      jar cf native-platform-linux-${arch}-${nativeVersion}.jar .
      mv native-platform-linux-${arch}-${nativeVersion}.jar $out/lib/gradle/lib/
      popd

      # The scanner doesn't pick up the runtime dependency in the jar.
      # Manually add a reference where it will be found.
      mkdir $out/nix-support
      echo ${stdenv.cc.cc} > $out/nix-support/manual-runtime-dependencies
    '';

    nativeBuildInputs = [ makeWrapper unzip ];
    buildInputs = [ java ];

    meta = {
      description = "Enterprise-grade build system";
      longDescription = ''
        Gradle is a build system which offers you ease, power and freedom.
        You can choose the balance for yourself. It has powerful multi-project
        build support. It has a layer on top of Ivy that provides a
        build-by-convention integration for Ivy. It gives you always the choice
        between the flexibility of Ant and the convenience of a
        build-by-convention behavior.
      '';
      homepage = "http://www.gradle.org/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.unix;
    };
  };

  gradle_latest = gradle_7;

  gradle_7 = gradleGen (gradleSpec {
    version = "7.2";
    nativeVersion = "0.22-milestone-21";
    sha256 = "1pg6w5czysywsgdvmll5bwd2p6y99cn5sn3gw69cps9mkjd710gm";
  });

  gradle_6_8 = gradleGen (gradleSpec {
    version = "6.8.3";
    nativeVersion = "0.22-milestone-9";
    sha256 = "01fjrk5nfdp6mldyblfmnkq2gv1rz1818kzgr0k2i1wzfsc73akz";
  });

  gradle_5_6 = gradleGen (gradleSpec {
    version = "5.6.4";
    nativeVersion = "0.18";
    sha256 = "1f3067073041bc44554d0efe5d402a33bc3d3c93cc39ab684f308586d732a80d";
  });

  gradle_4_10 = gradleGen (gradleSpec {
    version = "4.10.3";
    nativeVersion = "0.14";
    sha256 = "0vhqxnk0yj3q9jam5w4kpia70i4h0q4pjxxqwynh3qml0vrcn9l6";
  });
}
