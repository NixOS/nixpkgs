{
  buildPythonPackage,
  installShellFiles,
  rustPlatform,
  pkgs,
  versionCheckHook,
}:

buildPythonPackage {
  inherit (pkgs.uv)
    pname
    version
    src
    cargoDeps
    meta
    cargoBuildFlags
    postInstall
    versionCheckProgramArg
    ;

  postPatch = ''
    substituteInPlace python/uv/_find_uv.py \
      --replace-fail '"""Return the uv binary path."""' "return '$out/bin/uv'"
  '';

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [ versionCheckHook ];

  pyproject = true;
  pythonImportsCheck = [ "uv" ];
}
