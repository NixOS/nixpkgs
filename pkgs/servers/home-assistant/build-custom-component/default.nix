{
  lib,
  home-assistant,
  makeSetupHook,
  ...
}:

let
  inherit (home-assistant) python3Packages;

  manifestRequirementsCheckHook = import ./manifest-requirements-check-hook.nix {
    inherit lib makeSetupHook python3Packages;
  };
in

lib.extendMkDerivation {
  constructDrv = python3Packages.buildPythonPackage;
  excludeDrvArgNames = [
    "meta"
    "nativeBuildInputs"
    "passthru"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      owner,
      domain,
      version,
      ...
    }@args:
    {
      pname = "${owner}/${domain}";
      inherit version;
      pyproject = false;

      installPhase = ''
        runHook preInstall

        mkdir $out
        if [[ -f ./manifest.json ]]; then
          mkdir $out/custom_components
          cp -R "$(realpath .)" "$out/custom_components/${domain}"
        else
          cp -r ./custom_components/ $out/
        fi

        # optionally copy sentences, if they exist
        if [[ -d ./custom_sentences ]]; then
          cp -r ./custom_sentences/ $out/
        fi

        runHook postInstall
      '';

      nativeBuildInputs =
        with home-assistant.python3Packages;
        [
          manifestRequirementsCheckHook
          packaging
        ]
        ++ (args.nativeBuildInputs or [ ]);

      passthru = {
        isHomeAssistantComponent = true;
      }
      // args.passthru or { };

      meta = {
        inherit (home-assistant.meta) platforms;
      }
      // args.meta or { };

    };
}
