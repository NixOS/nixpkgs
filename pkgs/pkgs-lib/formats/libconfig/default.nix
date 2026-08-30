{
  lib,
  pkgs,
}:
let
  inherit (pkgs) buildPackages callPackage;

  libconfig-generator = buildPackages.rustPlatform.buildRustPackage {
    name = "libconfig-generator";
    version = "0.1.0";
    src = ./src;

    passthru.updateScript = ./update.sh;

    cargoLock.lockFile = ./src/Cargo.lock;
  };

  libconfig-validator =
    buildPackages.runCommandCC "libconfig-validator"
      {
        buildInputs = with buildPackages; [ libconfig ];
      }
      ''
        mkdir -p "$out/bin"
        $CC -lconfig -x c - -o "$out/bin/libconfig-validator" ${./validator.c}
      '';
in
{
  format =
    {
      generator ? libconfig-generator,
      validator ? libconfig-validator,
    }:
    {
      inherit generator;

      type =
        with lib.types;
        let
          valueType =
            (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "libconfig value";
            };
        in
        attrsOf valueType;

      lib = {
        mkHex = value: {
          _type = "hex";
          inherit value;
        };
        mkOctal = value: {
          _type = "octal";
          inherit value;
        };
        mkFloat = value: {
          _type = "float";
          inherit value;
        };
        mkArray = value: {
          _type = "array";
          inherit value;
        };
        mkList = value: {
          _type = "list";
          inherit value;
        };
      };

      generate =
        name: value:
        callPackage
          (
            {
              stdenvNoCC,
              libconfig-generator,
              libconfig-validator,
              writeText,
            }:
            stdenvNoCC.mkDerivation (finalAttrs: {
              inherit name;

              dontUnpack = true;
              preferLocalBuild = true;

              json = builtins.toJSON value;

              strictDeps = true;
              nativeBuildInputs = [ libconfig-generator ];
              buildPhase = ''
                runHook preBuild
                printf "%s" "$json" | libconfig-generator > output.cfg
                runHook postBuild
              '';

              doCheck = true;
              nativeCheckInputs = [ libconfig-validator ];
              checkPhase = ''
                runHook preCheck
                libconfig-validator output.cfg
                runHook postCheck
              '';

              installPhase = ''
                runHook preInstall
                mv output.cfg $out
                runHook postInstall
              '';

              __structuredAttrs = true;

              passthru.json = writeText "${finalAttrs.name}.json" finalAttrs.json;
            })
          )
          {
            libconfig-generator = generator;
            libconfig-validator = validator;
          };
    };
}
