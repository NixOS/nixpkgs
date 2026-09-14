{
  lib,
  stdenv,
  unzip,
  jdk,
  gradle,
  ghidra,
  replaceVars,
}:

let
  metaCommon =
    oldMeta:
    oldMeta
    // {
      maintainers =
        (oldMeta.maintainers or [ ])
        ++ (with lib.maintainers; [
          vringar
          ivyfanchiang
        ]);
      platforms = oldMeta.platforms or ghidra.meta.platforms;
    };

  buildGhidraExtension = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;
    extendDrvArgs =
      finalAttrs:
      {
        pname,
        nativeBuildInputs ? [ ],
        meta ? { },
        ...
      }@args:
      {
        nativeBuildInputs = nativeBuildInputs ++ [
          unzip
          jdk
          gradle
        ];

        preBuild = ''
          ${lib.optionalString stdenv.hostPlatform.isDarwin ''
            gradleJvmArgs="-Xms64m -Xmx2G -Dfile.encoding=UTF-8 -Duser.language=en -Duser.country=US -Duser.variant"
            if [[ -n "''${MITM_CACHE_KEYSTORE-}" ]]; then
              gradleJvmArgs+=" -Dhttp.proxyHost=$MITM_CACHE_HOST -Dhttp.proxyPort=$MITM_CACHE_PORT"
              gradleJvmArgs+=" -Dhttps.proxyHost=$MITM_CACHE_HOST -Dhttps.proxyPort=$MITM_CACHE_PORT"
              gradleJvmArgs+=" -Djavax.net.ssl.trustStore=$MITM_CACHE_KEYSTORE -Djavax.net.ssl.trustStorePassword=$MITM_CACHE_KS_PWD"
            fi
            echo "org.gradle.jvmargs=$gradleJvmArgs" >> gradle.properties
            export GRADLE_OPTS="$gradleJvmArgs ''${GRADLE_OPTS:-}"
          ''}

          # Set project name, otherwise defaults to directory name
          echo -e '\nrootProject.name = "${pname}"' >> settings.gradle
          # A config directory needs to exist when ghidra's GHelpBuilder is run
          export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$(mktemp -d)}"
          ${args.preBuild or ""}
        '';

        # Needed to run gradle on darwin
        __darwinAllowLocalNetworking = true;
        enableParallelBuilding = args.enableParallelBuilding or (!stdenv.hostPlatform.isDarwin);

        gradleBuildTask = args.gradleBuildTask or "buildExtension";
        gradleFlags =
          (args.gradleFlags or [ ])
          ++ [ "-PGHIDRA_INSTALL_DIR=${ghidra}/lib/ghidra" ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            "--max-workers=1"
            "--init-script"
            "${./darwin-javac-init.gradle}"
            "-PNIX_JAVAC=${jdk}/bin/javac"
          ];

        installPhase =
          args.installPhase or ''
            runHook preInstall

            mkdir -p $out/lib/ghidra/Ghidra/Extensions
            unzip -d $out/lib/ghidra/Ghidra/Extensions dist/*.zip

            # Prevent attempted creation of plugin lock files in the Nix store.
            for i in $out/lib/ghidra/Ghidra/Extensions/*; do
              touch "$i/.dbDirLock"
            done

            runHook postInstall
          '';

        meta = metaCommon meta;
      };
  };

  buildGhidraScripts = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;
    extendDrvArgs =
      finalAttrs:
      {
        pname,
        meta ? { },
        ...
      }@args:
      let
        extensionProperties = replaceVars ./script-extension.properties.in {
          inherit pname;
          description = meta.description or "";
          version = lib.getVersion ghidra;
        };
      in
      {
        installPhase = ''
          runHook preInstall

          GHIDRA_HOME=$out/lib/ghidra/Ghidra/Extensions/${pname}
          mkdir -p $GHIDRA_HOME
          cp -r . $GHIDRA_HOME/ghidra_scripts

          touch $GHIDRA_HOME/Module.manifest
          cp ${extensionProperties} "$GHIDRA_HOME/extension.properties"

          runHook postInstall
        '';

        meta = metaCommon meta;
      };
  };
in
{
  inherit buildGhidraExtension buildGhidraScripts;
}
