{ lib, stdenv, fetchurl, unzip, jdk, java ? jdk, makeWrapper }:

rec {
  gradleGen = { version, nativeVersion, sha256, toolchains ? { } }: stdenv.mkDerivation {
    pname = "gradle";
    inherit version;

    src = fetchurl {
      inherit sha256;
      url = "https://services.gradle.org/distributions/gradle-${version}-bin.zip";
    };

    dontBuild = true;

    nativeBuildInputs = [ makeWrapper unzip ];
    buildInputs = [ java ];

    # NOTE: For more information on toolchains, see https://docs.gradle.org/current/userguide/toolchains.html
    installPhase = let toolchain = with builtins; rec {
      var = x: "GRADLE_TOOLCHAIN_${lib.toUpper x}";
      vars = map var (attrNames toolchains);
      have = 0 == length vars;
      setVars = if have then "" else "\n" + mapAttrs (name: value: ("--set ${var name} ${value} \\\n")) toolchains;
      property = if have then "" else " -Porg.gradle.java.installations.fromEnv=${concatStringsSep "," vars}";
    }; in ''
      mkdir -pv $out/lib/gradle/
      cp -rv lib/ $out/lib/gradle/

      gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
      test -f $gradle_launcher_jar
      makeWrapper ${java}/bin/java $out/bin/gradle \
        --set JAVA_HOME ${java} \${toolchain.setVars}
        --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain${toolchain.property}"
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
      homepage = "https://www.gradle.org/";
      changelog = "https://docs.gradle.org/${version}/release-notes.html";
      downloadPage = "https://gradle.org/next-steps/?version=${version}";
      license = licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ lorenzleutgeb ];
    };
  };

  gradle_latest = gradle_7_3;

  gradle_7_3 = gradleGen (import ./gradle-7.3-spec.nix);
  gradle_6_9 = gradleGen (import ./gradle-6.9.1-spec.nix);

  # NOTE: No GitHub Release for the following versions. Update.sh will not work.
  gradle_5_6 = gradleGen (import ./gradle-5.6.4-spec.nix);
  gradle_4_10 = gradleGen (import ./gradle-4.10.3-spec.nix);
}
