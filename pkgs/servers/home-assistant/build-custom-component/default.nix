{
  lib,
  home-assistant,
  makeSetupHook,
}:

{
  owner,
  domain,
  version,
  format ? "other",
  ...
}@args:

let
  manifestRequirementsCheckHook = import ./manifest-requirements-check-hook.nix {
    inherit makeSetupHook;
    inherit (home-assistant) python;
  };
in
home-assistant.python.pkgs.buildPythonPackage (
  {
    pname = "${owner}/${domain}";
    inherit format;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r ./custom_components/ $out/

      # optionally copy sentences, if they exist
      cp -r ./custom_sentences/ $out/ || true

      runHook postInstall
    '';

    nativeCheckInputs =
      with home-assistant.python.pkgs;
      [
        importlib-metadata
        manifestRequirementsCheckHook
        packaging
      ]
      ++ (args.nativeCheckInputs or [ ]);

    passthru = {
      isHomeAssistantComponent = true;
    } // args.passthru or { };

    meta = {
      inherit (home-assistant.meta) platforms;
    } // args.meta or { };

  }
  // builtins.removeAttrs args [
    "meta"
    "nativeCheckInputs"
    "passthru"
  ]
)
