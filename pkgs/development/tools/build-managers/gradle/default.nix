{ stdenv, fetchurl, unzip, jdk, java ? jdk, makeWrapper }:

rec {
  gradleGen = {name, src, nativeVersion} : stdenv.mkDerivation {
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

    buildInputs = [ unzip java makeWrapper ];

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

  gradle_latest = gradle_5_6;

  gradle_5_6 = gradleGen rec {
    name = "gradle-5.6.1";
    nativeVersion = "0.18";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "04pccfcry5c59xwm6rr4r3baanwbfr5yrwhxv4r5v8z4414291h9";
    };
  };

  gradle_4_10 = gradleGen rec {
    name = "gradle-4.10.3";
    nativeVersion = "0.14";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "0vhqxnk0yj3q9jam5w4kpia70i4h0q4pjxxqwynh3qml0vrcn9l6";
    };
  };

  gradle_3_5 = gradleGen rec {
    name = "gradle-3.5.1";
    nativeVersion = "0.14";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "1y7fbhrdriclbs5ksxahi0aafsz760lalwyz8r4llysc5pskbkld";
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

  # Nix pkgs that depend on this old version:
  # pkgs/tools/security/jd-gui/default.nix
  # pkgs/servers/mxisd/default.nix
  # If these packages are updated, this old version can probably be removed
  gradle_2_5 = gradleGen rec {
    name = "gradle-2.5";
    nativeVersion = "0.10";

    src = fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "0mc5lf6phkncx77r0papzmfvyiqm0y26x50ipvmzkcsbn463x59z";
    };
  };
}
