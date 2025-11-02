{
  callPackage,
  jdk11,
  jdk17,
  jdk21,
}:

let
  wrapGradle =
    {
      lib,
      callPackage,
      mitm-cache,
      replaceVars,
      symlinkJoin,
      concatTextFile,
      makeSetupHook,
      nix-update-script,

      # This is the "current" version of gradle in nixpkgs.
      # Used to define the update script.
      gradle-unwrapped,

      runCommand,
    }:
    this-gradle-unwrapped:
    lib.makeOverridable (
      args:
      let
        gradle = this-gradle-unwrapped.override args;
      in
      symlinkJoin {
        pname = "gradle";
        inherit (gradle) version;

        paths = [
          (makeSetupHook { name = "gradle-setup-hook"; } (concatTextFile {
            name = "setup-hook.sh";
            files = [
              (mitm-cache.setupHook)
              (replaceVars ./setup-hook.sh {
                # jdk used for keytool
                inherit (gradle) jdk;
                init_script = "${./init-build.gradle}";
              })
            ];
          }))
          gradle
          mitm-cache
        ];

        passthru = {
          fetchDeps = callPackage ./fetch-deps.nix { inherit mitm-cache; };
          inherit (gradle) jdk;
          unwrapped = gradle;
          tests = {
            toolchains =
              let
                javaVersion = lib.getVersion jdk11;
                javaMajorVersion = lib.versions.major javaVersion;
              in
              runCommand "detects-toolchains-from-nix-env"
                {
                  # Use JDKs that are not the default for any of the gradle versions
                  nativeBuildInputs = [
                    (gradle.override {
                      javaToolchains = [
                        jdk11
                      ];
                    })
                  ];
                  src = ./tests/toolchains;
                }
                ''
                  cp -a $src/* .
                  substituteInPlace ./build.gradle --replace-fail '@JAVA_VERSION@' '${javaMajorVersion}'
                  env GRADLE_USER_HOME=$TMPDIR/gradle org.gradle.native.dir=$TMPDIR/native \
                  gradle run --no-daemon --quiet --console plain > $out
                  actual="$(<$out)"
                  if [[ "${javaVersion}" != "$actual"* ]]; then
                    echo "Error: Expected '${javaVersion}', to start with '$actual'" >&2
                    exit 1
                  fi
                '';
          }
          // gradle.tests;
        }
        // lib.optionalAttrs (this-gradle-unwrapped == gradle-unwrapped) {
          updateScript = nix-update-script {
            extraArgs = [
              "--url=https://github.com/gradle/gradle"
              # Gradle’s .0 releases are tagged as `vX.Y.0`, but the actual
              # release version omits the `.0`, so we’ll wanto to only capture
              # the version up but not including the the trailing `.0`.
              "--version-regex=^v(\\d+\\.\\d+(?:\\.[1-9]\\d?)?)(\\.0)?$"
            ];
          };
        };

        meta = gradle.meta // {
          # prefer normal gradle/mitm-cache over this wrapper, this wrapper only provides the setup hook
          # and passthru
          priority = (gradle.meta.priority or lib.meta.defaultPriority) + 1;
        };
      }
    ) { };

  gen =
    {
      version,
      hash,

      # The default JDK/JRE that will be used for derived Gradle packages.
      # A current LTS version of a JDK is a good choice.
      defaultJava,

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

      # Extra attributes to be merged into the resulting derivation's
      # meta attribute.
      meta ? { },
    }@genArgs:

    {
      lib,
      stdenv,
      fetchurl,
      callPackage,
      makeWrapper,
      unzip,
      ncurses5,
      ncurses6,
      udev,
      testers,
      runCommand,
      writeText,
      autoPatchelfHook,
      buildPackages,

      # The JDK/JRE used for running Gradle.
      java ? defaultJava,

      # Additional JDK/JREs to be registered as toolchains.
      # See https://docs.gradle.org/current/userguide/toolchains.html
      javaToolchains ? [ ],
    }:

    stdenv.mkDerivation (finalAttrs: {
      pname = "gradle";
      inherit version;

      src = fetchurl {
        inherit hash;
        url = "https://services.gradle.org/distributions/gradle-${version}-bin.zip";
      };

      dontBuild = true;

      nativeBuildInputs = [
        makeWrapper
        unzip
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        autoPatchelfHook
      ];

      buildInputs = [
        stdenv.cc.cc
        ncurses5
        ncurses6
      ];

      # We only need to patchelf some libs embedded in JARs.
      dontAutoPatchelf = true;

      installPhase =
        with builtins;
        let
          # set toolchains via installations.path property in gradle.properties.
          # See https://docs.gradle.org/current/userguide/toolchains.html#sec:custom_loc
          toolchainPaths = "org.gradle.java.installations.paths=${concatStringsSep "," javaToolchains}";
          jnaLibraryPath = if stdenv.hostPlatform.isLinux then lib.makeLibraryPath [ udev ] else "";
          jnaFlag =
            if stdenv.hostPlatform.isLinux then "--add-flags \"-Djna.library.path=${jnaLibraryPath}\"" else "";
        in
        ''
          mkdir -pv $out/lib/gradle/
          cp -rv lib/ $out/lib/gradle/

          gradle_launcher_jar=$(echo $out/lib/gradle/lib/gradle-launcher-*.jar)
          test -f $gradle_launcher_jar
          makeWrapper ${java}/bin/java $out/bin/gradle \
            --set JAVA_HOME ${java} \
            ${jnaFlag} \
            --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain"

          echo "${toolchainPaths}" > $out/lib/gradle/gradle.properties
        '';

      dontFixup = !stdenv.hostPlatform.isLinux;

      fixupPhase =
        let
          arch = if stdenv.hostPlatform.is64bit then "amd64" else "i386";
          newFileEvents = toString (lib.versionAtLeast version "8.12");
        in
        ''
          # get the correct jar executable for cross
          export PATH="${buildPackages.jdk}/bin:$PATH"
          . ${./patching.sh}

          nativeVersion="$(extractVersion native-platform $out/lib/gradle/lib/native-platform-*.jar)"
          for variant in "" "-ncurses5" "-ncurses6"; do
            autoPatchelfInJar \
              $out/lib/gradle/lib/native-platform-linux-${arch}$variant-''${nativeVersion}.jar \
              "${lib.getLib stdenv.cc.cc}/lib64:${
                lib.makeLibraryPath [
                  stdenv.cc.cc
                  ncurses5
                  ncurses6
                ]
              }"
          done

          # The file-events library _seems_ to follow the native-platform version, but
          # we won’t assume that.
          if [ -n "${newFileEvents}" ]; then
            fileEventsVersion="$(extractVersion gradle-fileevents $out/lib/gradle/lib/gradle-fileevents-*.jar)"
            autoPatchelfInJar \
              $out/lib/gradle/lib/gradle-fileevents-''${fileEventsVersion}.jar \
              "${lib.getLib stdenv.cc.cc}/lib64:${lib.makeLibraryPath [ stdenv.cc.cc ]}"
          else
            fileEventsVersion="$(extractVersion file-events $out/lib/gradle/lib/file-events-*.jar)"
            autoPatchelfInJar \
              $out/lib/gradle/lib/file-events-linux-${arch}-''${fileEventsVersion}.jar \
              "${lib.getLib stdenv.cc.cc}/lib64:${lib.makeLibraryPath [ stdenv.cc.cc ]}"
          fi

          # The scanner doesn't pick up the runtime dependency in the jar.
          # Manually add a reference where it will be found.
          mkdir $out/nix-support
          echo ${stdenv.cc.cc} > $out/nix-support/manual-runtime-dependencies
          # Gradle will refuse to start without _both_ 5 and 6 versions of ncurses.
          echo ${ncurses5} >> $out/nix-support/manual-runtime-dependencies
          echo ${ncurses6} >> $out/nix-support/manual-runtime-dependencies
          ${lib.optionalString stdenv.hostPlatform.isLinux "echo ${udev} >> $out/nix-support/manual-runtime-dependencies"}
        '';

      passthru.tests = {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = ''
            env GRADLE_USER_HOME=$TMPDIR/gradle org.gradle.native.dir=$TMPDIR/native \
              gradle --version
          '';
        };

        java-application = testers.testEqualContents {
          assertion = "can build and run a trivial Java application";
          expected = writeText "expected" "hello\n";
          actual =
            runCommand "actual"
              {
                nativeBuildInputs = [ finalAttrs.finalPackage ];
                src = ./tests/java-application;
              }
              ''
                cp -a $src/* .
                env GRADLE_USER_HOME=$TMPDIR/gradle org.gradle.native.dir=$TMPDIR/native \
                  gradle run --no-daemon --quiet --console plain > $out
              '';
        };
      };
      passthru.jdk = defaultJava;
      passthru.wrapped = callPackage wrapGradle { } (gen' genArgs);

      meta =
        with lib;
        {
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
          maintainers = with maintainers; [
            britter
            liff
            lorenzleutgeb
          ];
          teams = [ lib.teams.java ];
          mainProgram = "gradle";
        }
        // meta;
    });

  # Calls the generated Gradle package with default arguments.
  gen' = args: callPackage (gen args) { };
in
rec {
  # NOTE: Default JDKs that are hardcoded below must be LTS versions
  # and respect the compatibility matrix at
  # https://docs.gradle.org/current/userguide/compatibility.html

  gradle_9 = gen' {
    version = "9.1.0";
    hash = "sha256-oX3dhaJran9d23H/iwX8UQTAICxuZHgkKXkMkzaGyAY=";
    defaultJava = jdk21;
  };
  gradle_8 = gen' {
    version = "8.14.3";
    hash = "sha256-vXEQIhNJMGCVbsIp2Ua+7lcVjb2J0OYrkbyg+ixfNTE=";
    defaultJava = jdk21;
  };
  gradle_7 = gen' {
    version = "7.6.6";
    hash = "sha256-Zz2XdvMDvHBI/DMp0jLW6/EFGweJO9nRFhb62ahnO+A=";
    defaultJava = jdk17;
    meta.knownVulnerabilities = [
      "Gradle 7 no longer receives security updates with the release of Gradle 9 on 31 July 2025. https://endoflife.date/gradle"
    ];
  };

  # Default version of Gradle in nixpkgs.
  gradle = gradle_8;
}
