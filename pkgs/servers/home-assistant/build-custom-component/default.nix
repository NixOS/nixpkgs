{ lib
, home-assistant
, makeSetupHook
}:

{ pname
, version
, format ? "other"
, ...
}@args:

let
  manifestRequirementsCheckHook = import ./manifest-requirements-check-hook.nix {
    inherit makeSetupHook;
    inherit (home-assistant) python;
  };
in
home-assistant.python.pkgs.buildPythonPackage (
  {
    inherit format;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r $src/custom_components/ $out/

      runHook postInstall
    '';

    nativeCheckInputs = with home-assistant.python.pkgs; [
      importlib-metadata
      manifestRequirementsCheckHook
      packaging
    ] ++ (args.nativeCheckInputs or []);

  } // builtins.removeAttrs args [ "nativeCheckInputs" ]
)
