{ stdenv, fetchurl, unzip, jdk, makeWrapper }:

rec {
  gradleGen = {name, src, nativeVersion} : stdenv.mkDerivation rec {
    inherit name src nativeVersion;

    dontBuild = true;

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
      platforms = stdenv.lib.platforms.unix;
    };
  };

  gradle_latest = gradleGen rec {
    name = "gradle-3.4.1";
    nativeVersion = "0.13";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "1cpria3qry4778pxcmqvnaqcyq36abj1fgw4pq115k3rsj9v27fv";
    };
  };

  gradle_2_14 = gradleGen rec {
    name = "gradle-2.14.1";
    nativeVersion = "0.10";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "0fggjxpsnakdaviw7bn2jmsl06997phlqr1251bjmlgjf7d1xing";
    };
  };

  gradle_2_5 = gradleGen rec {
    name = "gradle-2.5";
    nativeVersion = "0.10";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "0mc5lf6phkncx77r0papzmfvyiqm0y26x50ipvmzkcsbn463x59z";
    };
  };
}
