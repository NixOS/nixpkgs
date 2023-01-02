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
      ],

      # Set to true if this Gradle version supports JVM toolchains
      # (see here for more info: https://docs.gradle.org/current/userguide/toolchains.html#sec:consuming).
      #
      # Toolchains were added in Gradle 6.7. For >=6.7 versions, set this to
      # true (or false if you want to disable this package's toolchain support).
      # For <6.7 versions, set this to false or passthru.tests will fail!
      #
      # If true, this will enable the 'toolchains' attreibute and generate a
      # test in passthru.tests that verifies that:
      # a) The package can be used with Java toolchains via the javaToolchains
      #    argument
      # b) Gradle correctly picks up toolchains managed via this package
      hasToolchainSupport ? false
    }:

    let
      builder =
        args@{ lib, stdenv, fetchurl, makeWrapper, unzip, ncurses5, ncurses6, callPackage,

          # The JDK/JRE used for running Gradle.
          java ? defaultJava,

          # Additional JDK/JREs to be registered as toolchains.
          # See https://docs.gradle.org/current/userguide/toolchains.html
          javaToolchains ? [ ]
        }:

        let
          gradle = stdenv.mkDerivation rec {
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
                javaHomeProperty = "org.gradle.java.home=" + java;
                toolchainsProperty = "org.gradle.java.installations.paths=" + (concatStringsSep "," javaToolchains);
                toolchainsPropertyWithCheck = 
                if (hasToolchainSupport || (length javaToolchains) == 0) then toolchainsProperty
                else lib.warn "This Gradle version (${version}) does not have toolchain support, yet the 'javaToolchains' list is not empty. The used toolchain will be ignored by Gradle." toolchainsProperty;
                propDefs = concatStringsSep "\n" [ javaHomeProperty toolchainsPropertyWithCheck ];
              in
              ''
                mkdir -pv $out/lib/gradle/
                cp -rv lib/ $out/lib/gradle/

                gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
                test -f $gradle_launcher_jar
                echo '${propDefs}' > $out/lib/gradle/gradle.properties
                makeWrapper ${java}/bin/java $out/bin/gradle \
                  --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain"
              '';

            dontFixup = !stdenv.isLinux;

            fixupPhase =
              let arch = if stdenv.is64bit then "amd64" else "i386";
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

            passthru.tests = (callPackage ./tests.nix { }) { inherit gradle; } //
              lib.optionalAttrs hasToolchainSupport {
                gradleWithToolchains =
                  let
                    toolchains = [ jdk11 jdk17 ];
                  in
                  if javaToolchains == toolchains then gradle # Avoids infinite recursion
                  else builder (args // { javaToolchains = toolchains; });
              };
          };
        in
        gradle;
    in
    builder;

  # NOTE: Default JDKs that are hardcoded below must be LTS versions
  # and respect the compatibility matrix at
  # https://docs.gradle.org/current/userguide/compatibility.html

  gradle_8 = gen {
    version = "8.0.1";
    nativeVersion = "0.22-milestone-24";
    sha256 = "02g9i1mrpdydj8d6395cv6a4ny9fw3z7sjzr7n6l6a9zx65masqv";
    defaultJava = jdk17;
  };

  gradle_7 = gen {
    version = "7.6.1";
    nativeVersion = "0.22-milestone-24";
    sha256 = "11qz1xjfihnlvsblqqnd49kmvjq86pzqcylj6k1zdvxl4dd60iv1";
    defaultJava = jdk17;
    hasToolchainSupport = true;
  };

  gradle_6 = gen {
    version = "6.9.4";
    nativeVersion = "0.22-milestone-20";
    sha256 = "16iqh4bn7ndch51h2lgkdqyyhnd91fdfjx55fa3z3scdacl0491y";
    defaultJava = jdk11;
    hasToolchainSupport = true;
  };
}
