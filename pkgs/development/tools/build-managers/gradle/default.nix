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

    meta = with lib; {
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
      license = licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ lorenzleutgeb ];
    };
  };

  gradle_latest = gradle_7_3;
  gradle_7_3 = gradleGen (gradleSpec (import ./gradle-7.3-spec.nix));
  gradle_6_9 = gradleGen (gradleSpec (import ./gradle-6.9.1-spec.nix));

  # NOTE: No GitHub Release for this release, so update.sh does not work.
  gradle_5_6 = gradleGen (gradleSpec {
    version = "5.6.4";
    nativeVersion = "0.18";
    sha256 = "03d86bbqd19h9xlanffcjcy3vg1k5905vzhf9mal9g21603nfc0z";
  });

  # NOTE: No GitHub Release for this release, so update.sh does not work.
  gradle_4_10 = gradleGen (gradleSpec {
    version = "4.10.3";
    nativeVersion = "0.14";
    sha256 = "0vhqxnk0yj3q9jam5w4kpia70i4h0q4pjxxqwynh3qml0vrcn9l6";
  });
}
