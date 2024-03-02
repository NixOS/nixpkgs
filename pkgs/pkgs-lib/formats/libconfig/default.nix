{ lib
, pkgs
}:
let
  inherit (pkgs) buildPackages callPackage;
  # Implementation notes:
  #   Libconfig spec: https://hyperrealm.github.io/libconfig/libconfig_manual.html
  #
  #   Since libconfig does not allow setting names to start with an underscore,
  #   this is used as a prefix for both special types and include directives.
  #
  #   The difference between 32bit and 64bit values became optional in libconfig
  #   1.5, so we assume 64bit values for all numbers.

  libconfig-generator = buildPackages.rustPlatform.buildRustPackage {
    name = "libconfig-generator";
    version = "0.1.0";
    src = ./src;

    passthru.updateScript = ./update.sh;

    cargoLock.lockFile = ./src/Cargo.lock;
  };

  libconfig-validator = buildPackages.runCommandCC "libconfig-validator"
    {
      buildInputs = with buildPackages; [ libconfig ];
    }
    ''
      mkdir -p "$out/bin"
      $CC -lconfig -x c - -o "$out/bin/libconfig-validator" ${./validator.c}
    '';
in
{
  format = { generator ? libconfig-generator, validator ? libconfig-validator }: {
    inherit generator;

    type = with lib.types;
      let
        valueType = (oneOf [
          bool
          int
          float
          str
          path
          (attrsOf valueType)
          (listOf valueType)
        ]) // {
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

    generate = name: value:
      callPackage
        ({
          stdenvNoCC
        , libconfig-generator
        , libconfig-validator
        , writeText
        }: stdenvNoCC.mkDerivation rec {
          inherit name;

          dontUnpack = true;

          json = builtins.toJSON value;
          passAsFile = [ "json" ];

          strictDeps = true;
          nativeBuildInputs = [ libconfig-generator ];
          buildPhase = ''
            runHook preBuild
            libconfig-generator < $jsonPath > output.cfg
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

          passthru.json = writeText "${name}.json" json;
        })
        {
          libconfig-generator = generator;
          libconfig-validator = validator;
        };
  };
}
