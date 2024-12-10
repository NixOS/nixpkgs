{
  lib,
  pkgs,
}:
let
  inherit (pkgs) buildPackages callPackage;

  hocon-generator = buildPackages.rustPlatform.buildRustPackage {
    name = "hocon-generator";
    version = "0.1.0";
    src = ./src;

    passthru.updateScript = ./update.sh;

    cargoLock.lockFile = ./src/Cargo.lock;
  };

  hocon-validator =
    pkgs.writers.writePython3Bin "hocon-validator"
      {
        libraries = [ pkgs.python3Packages.pyhocon ];
      }
      ''
        from sys import argv
        from pyhocon import ConfigFactory

        if not len(argv) == 2:
            print("USAGE: hocon-validator <file>")

        ConfigFactory.parse_file(argv[1])
      '';
in
{
  format =
    {
      generator ? hocon-generator,
      validator ? hocon-validator,
      doCheck ? true,
    }:
    let
      hoconLib = {
        mkInclude =
          value:
          let
            includeStatement =
              if lib.isAttrs value && !(lib.isDerivation value) then
                {
                  required = false;
                  type = null;
                  _type = "include";
                }
                // value
              else
                {
                  value = toString value;
                  required = false;
                  type = null;
                  _type = "include";
                };
          in
          assert lib.assertMsg
            (lib.elem includeStatement.type [
              "file"
              "url"
              "classpath"
              null
            ])
            ''
              Type of HOCON mkInclude is not of type 'file', 'url' or 'classpath':
              ${(lib.generators.toPretty { }) includeStatement}
            '';
          includeStatement;

        mkAppend = value: {
          inherit value;
          _type = "append";
        };

        mkSubstitution =
          value:
          if lib.isString value then
            {
              inherit value;
              optional = false;
              _type = "substitution";
            }
          else
            assert lib.assertMsg (lib.isAttrs value) ''
              Value of invalid type provided to `hocon.lib.mkSubstition`: ${lib.typeOf value}
            '';
            assert lib.assertMsg (value ? "value") ''
              Argument to `hocon.lib.mkSubstition` is missing a `value`:
              ${builtins.toJSON value}
            '';
            {
              value = value.value;
              optional = value.optional or false;
              _type = "substitution";
            };
      };

    in
    {
      type =
        let
          type' =
            with lib.types;
            let
              atomType = nullOr (oneOf [
                bool
                float
                int
                path
                str
              ]);
            in
            (oneOf [
              atomType
              (listOf atomType)
              (attrsOf type')
            ])
            // {
              description = "HOCON value";
            };
        in
        type';

      lib = hoconLib;

      generate =
        name: value:
        let
          # TODO: remove in 24.11
          # Backwards compatibility for generators in the following locations:
          #  - nixos/modules/services/networking/jibri/default.nix (__hocon_envvar)
          #  - nixos/modules/services/networking/jicofo.nix (__hocon_envvar, __hocon_unquoted_string)
          #  - nixos/modules/services/networking/jitsi-videobridge.nix (__hocon_envvar)
          replaceOldIndicators =
            value:
            if lib.isAttrs value then
              (
                if value ? "__hocon_envvar" then
                  lib.warn ''
                    Use of `__hocon_envvar` has been deprecated, and will
                    be removed in the future.

                    Please use `(pkgs.formats.hocon {}).lib.mkSubstitution` instead.
                  '' (hoconLib.mkSubstitution value.__hocon_envvar)
                else if value ? "__hocon_unquoted_string" then
                  lib.warn
                    ''
                      Use of `__hocon_unquoted_string` has been deprecated, and will
                      be removed in the future.

                      Please make use of the freeform options of
                      `(pkgs.formats.hocon {}).format` instead.
                    ''
                    {
                      value = value.__hocon_unquoted_string;
                      _type = "unquoted_string";
                    }
                else
                  lib.mapAttrs (_: replaceOldIndicators) value
              )
            else if lib.isList value then
              map replaceOldIndicators value
            else
              value;

          finalValue = replaceOldIndicators value;
        in
        callPackage
          (
            {
              stdenvNoCC,
              hocon-generator,
              hocon-validator,
              writeText,
            }:
            stdenvNoCC.mkDerivation rec {
              inherit name;

              dontUnpack = true;

              json = builtins.toJSON finalValue;
              passAsFile = [ "json" ];

              strictDeps = true;
              nativeBuildInputs = [ hocon-generator ];
              buildPhase = ''
                runHook preBuild
                hocon-generator < $jsonPath > output.conf
                runHook postBuild
              '';

              inherit doCheck;
              nativeCheckInputs = [ hocon-validator ];
              checkPhase = ''
                runHook preCheck
                hocon-validator output.conf
                runHook postCheck
              '';

              installPhase = ''
                runHook preInstall
                mv output.conf $out
                runHook postInstall
              '';

              passthru.json = writeText "${name}.json" json;
            }
          )
          {
            hocon-generator = generator;
            hocon-validator = validator;
          };
    };
}
