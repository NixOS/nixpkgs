{ jdk8, jdk11, jdk17 }:

rec {
  gen =

    { version, nativeVersion, sha256,

      # The default JDK/JRE that will be used for derived Gradle packages.
      # A current LTS version of a JDK is a good choice.
      defaultJava ? jdk8,

      # The platforms supported by this Gradle package.
      # Gradle Native-Platform ships some binaries that
      # are compatible only with specific platforms.
      # As of 2022-04 this affects platform compatibility
      # of multiple Gradle releases, so this is used as default.
      # See https://github.com/gradle/native-platform#supported-platforms
      platforms ? [
        "aarch64-darwin"
        "aarch64-linux"
        "i686-windows"
        "x86_64-cygwin"
        "x86_64-darwin"
        "x86_64-linux"
        "x86_64-windows"
      ]
    }:

    { lib, stdenv, fetchurl, makeWrapper, unzip, ncurses5, ncurses6,

      # The JDK/JRE used for running Gradle.
      java ? defaultJava,

      # Additional JDK/JREs to be registered as toolchains.
      # See https://docs.gradle.org/current/userguide/toolchains.html
      javaToolchains ? [ ]
    }:

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

      installPhase = with builtins;
        let
          toolchain = rec {
            prefix = x: "JAVA_TOOLCHAIN_NIX_${toString x}";
            varDefs  = (lib.imap0 (i: x: "${prefix i} ${x}") javaToolchains);
            varNames = lib.imap0 (i: x: prefix i) javaToolchains;
            property = " -Porg.gradle.java.installations.fromEnv='${
                 concatStringsSep "," varNames
               }'";
          };
          varDefs = concatStringsSep "\n" (map (x: "  --set ${x} \\")
            ([ "JAVA_HOME ${java}" ] ++ toolchain.varDefs));
        in ''
          mkdir -pv $out/lib/gradle/
          cp -rv lib/ $out/lib/gradle/

          gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
          test -f $gradle_launcher_jar
          makeWrapper ${java}/bin/java $out/bin/gradle \
            ${varDefs}
            --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain${toolchain.property}"
        '';

      dontFixup = !stdenv.isLinux;

      fixupPhase = let arch = if stdenv.is64bit then "amd64" else "i386";
      in ''
        for variant in "" "-ncurses5" "-ncurses6"; do
          mkdir "patching$variant"
          pushd "patching$variant"
          jar xf $out/lib/gradle/lib/native-platform-linux-${arch}$variant-${nativeVersion}.jar
          patchelf \
            --set-rpath "${stdenv.cc.cc.lib}/lib64:${lib.makeLibraryPath [ stdenv.cc.cc ncurses5 ncurses6 ]}" \
            net/rubygrapefruit/platform/linux-${arch}$variant/libnative-platform*.so
          jar cf native-platform-linux-${arch}$variant-${nativeVersion}.jar .
          mv native-platform-linux-${arch}$variant-${nativeVersion}.jar $out/lib/gradle/lib/
          popd
        done

        # The scanner doesn't pick up the runtime dependency in the jar.
        # Manually add a reference where it will be found.
        mkdir $out/nix-support
        echo ${stdenv.cc.cc} > $out/nix-support/manual-runtime-dependencies
        # Gradle will refuse to start without _both_ 5 and 6 versions of ncurses.
        echo ${ncurses5} >> $out/nix-support/manual-runtime-dependencies
        echo ${ncurses6} >> $out/nix-support/manual-runtime-dependencies
      '';

      meta = with lib; {
        inherit platforms;
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
        sourceProvenance = with sourceTypes; [
          binaryBytecode
          binaryNativeCode
        ];
        license = licenses.asl20;
        maintainers = with maintainers; [ lorenzleutgeb liff ];
      };
    };

  # NOTE: Default JDKs that are hardcoded below must be LTS versions
  # and respect the compatibility matrix at
  # https://docs.gradle.org/current/userguide/compatibility.html

  gradle_7 = gen {
    version = "7.5";
    nativeVersion = "0.22-milestone-23";
    sha256 = "1hjifd98dif0qy6vkqp56v9z7id5cf2bfkdd71ld8nsqqlig51yb";
    defaultJava = jdk17;
  };

  gradle_6 = gen {
    version = "6.9.2";
    nativeVersion = "0.22-milestone-20";
    sha256 = "13qyk3f6namw27ynh6nxljxpk9r3l12vxl3f0qpglprdf3c6ydcb";
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
