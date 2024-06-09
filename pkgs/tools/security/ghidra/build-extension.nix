{ lib
, stdenv
, unzip
, jdk
, gradle
, ghidra
}:

let
  metaCommon = oldMeta:
    oldMeta // (with lib; {
      maintainers = (oldMeta.maintainers or []) ++ (with maintainers; [ vringar ]);
      platforms = oldMeta.platforms or ghidra.meta.platforms;
    });

  buildGhidraExtension = {
    pname, nativeBuildInputs ? [], meta ? { }, ...
  }@args:
    stdenv.mkDerivation (args // {
      nativeBuildInputs = nativeBuildInputs ++ [
        unzip
        jdk
        gradle
      ];

      buildPhase = args.buildPhase or ''
        runHook preBuild

        # Set project name, otherwise defaults to directory name
        echo -e '\nrootProject.name = "${pname}"' >> settings.gradle

        export GRADLE_USER_HOME=$(mktemp -d)
        gradle \
          --offline \
          --no-daemon \
          -PGHIDRA_INSTALL_DIR=${ghidra}/lib/ghidra

        runHook postBuild
      '';

      installPhase = args.installPhase or ''
        runHook preInstall

        mkdir -p $out/lib/ghidra/Ghidra/Extensions
        unzip -d $out/lib/ghidra/Ghidra/Extensions dist/*.zip

        runHook postInstall
      '';

      meta = metaCommon meta;
    });

  buildGhidraScripts = { pname, meta ? { }, ... }@args:
    stdenv.mkDerivation (args // {
      installPhase = ''
        runHook preInstall

        GHIDRA_HOME=$out/lib/ghidra/Ghidra/Extensions/${pname}
        mkdir -p $GHIDRA_HOME
        cp -r . $GHIDRA_HOME/ghidra_scripts

        touch $GHIDRA_HOME/Module.manifest
        cat <<'EOF' > extension.properties
        name=${pname}
        description=${meta.description or ""}
        author=
        createdOn=
        version=${lib.getVersion ghidra}

        EOF

        runHook postInstall
      '';

      meta = metaCommon meta;
    });
in
  { inherit buildGhidraExtension buildGhidraScripts; }
