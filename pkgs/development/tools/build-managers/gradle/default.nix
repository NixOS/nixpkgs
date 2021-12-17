{ jdk8, jdk11, jdk17 }:

rec {
  gen =

    { version, nativeVersion, sha256, defaultJava ? jdk8 }:

    { lib, stdenv, fetchurl, makeWrapper, unzip, java ? defaultJava
    , javaToolchains ? [ ] }:

    stdenv.mkDerivation rec {
      pname = "gradle";
      inherit version;

      src = fetchurl {
        inherit sha256;
        url =
          "https://services.gradle.org/distributions/gradle-${version}-bin.zip";
      };

      dontBuild = true;

      nativeBuildInputs = [ makeWrapper unzip ];
      buildInputs = [ java ];

      # NOTE: For more information on toolchains,
      # see https://docs.gradle.org/current/userguide/toolchains.html
      installPhase = with builtins;
        let
          toolchain = rec {
            var = x: "JAVA_TOOLCHAIN_NIX_${toString x}";
            vars = (lib.imap0 (i: x: ("${var i} ${x}")) javaToolchains);
            varNames = lib.imap0 (i: x: var i) javaToolchains;
            property = " -Porg.gradle.java.installations.fromEnv='${
                 concatStringsSep "," varNames
               }'";
          };
          vars = concatStringsSep "\n" (map (x: "  --set ${x} \\")
            ([ "JAVA_HOME ${java}" ] ++ toolchain.vars));
        in ''
          mkdir -pv $out/lib/gradle/
          cp -rv lib/ $out/lib/gradle/

          gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
          test -f $gradle_launcher_jar
          makeWrapper ${java}/bin/java $out/bin/gradle \
            ${vars}
            --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain${toolchain.property}"
        '';

      dontFixup = !stdenv.isLinux;

      fixupPhase = let arch = if stdenv.is64bit then "amd64" else "i386";
      in ''
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

  # NOTE: Default JDKs are LTS versions and according to
  # https://docs.gradle.org/current/userguide/compatibility.html

  gradle_7 = gen {
    version = "7.3.2";
    nativeVersion = "0.22-milestone-21";
    sha256 = "14jk1mhk59flzml55alwi9r5picmf8657q1nhd5mygrnmj79zf13";
    defaultJava = jdk17;
  };

  gradle_6 = gen {
    version = "6.9.1";
    nativeVersion = "0.22-milestone-20";
    sha256 = "1zmjfwlh34b65rdx9izgavw3qwqqwm39h5siyj2bf0m55111a4lc";
    defaultJava = jdk11;
  };

  # NOTE: No GitHub Release for the following versions. `update.sh` will not work.
  gradle_5 = gen {
    version = "5.6.4";
    nativeVersion = "0.18";
    sha256 = "03d86bbqd19h9xlanffcjcy3vg1k5905vzhf9mal9g21603nfc0z";
    defaultJava = jdk11;
  };

  gradle_4 = gen {
    version = "4.10.3";
    nativeVersion = "0.14";
    sha256 = "0vhqxnk0yj3q9jam5w4kpia70i4h0q4pjxxqwynh3qml0vrcn9l6";
    defaultJava = jdk8;
  };
}
