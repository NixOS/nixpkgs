{ stdenv, fetchurl, unzip, jdk, makeWrapper }:

rec {
  gradleGen = {name, src} : stdenv.mkDerivation rec {
    inherit name src;

    buildPhase = ":";

    installPhase = ''
      mkdir -pv $out/lib/gradle/
      cp -rv lib/ $out/lib/gradle/

      gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
      test -f $gradle_launcher_jar
      makeWrapper ${jdk}/bin/java $out/bin/gradle \
        --set JAVA_HOME ${jdk} \
        --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain"
    '';

    fixupPhase = if (!stdenv.isLinux) then ":" else
      let arch = if stdenv.is64bit then "amd64" else "i386"; in ''
        mkdir patching
        pushd patching
        jar xf $out/lib/gradle/lib/native-platform-linux-${arch}-0.10.jar
        patchelf --set-rpath "${stdenv.cc.cc.lib}/lib:${stdenv.cc.cc.lib}/lib64" net/rubygrapefruit/platform/linux-${arch}/libnative-platform.so
        jar cf native-platform-linux-${arch}-0.10.jar .
        mv native-platform-linux-${arch}-0.10.jar $out/lib/gradle/lib/
        popd

        # The scanner doesn't pick up the runtime dependency in the jar.
        # Manually add a reference where it will be found.
        mkdir $out/nix-support
        echo ${stdenv.cc.cc} > $out/nix-support/manual-runtime-dependencies
      '';

    buildInputs = [ unzip jdk makeWrapper ];

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
      homepage = http://www.gradle.org/;
      license = stdenv.lib.licenses.asl20;
    };
  };

  gradleLatest = gradleGen rec {
    name = "gradle-2.12";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "0p5b6dngza6c2lchz5j0w4cbsizpzvkf638yzxv09k8636c68w77";
    };
  };

  gradle25 = gradleGen rec {
    name = "gradle-2.5";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "0mc5lf6phkncx77r0papzmfvyiqm0y26x50ipvmzkcsbn463x59z";
    };
  };
}
