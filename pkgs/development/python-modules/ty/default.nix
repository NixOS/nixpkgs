{
  lib,
  buildPythonPackage,
  pkgs,
  rustPlatform,
  installShellFiles,
}:

buildPythonPackage {
  inherit (pkgs.ty)
    pname
    version
    src
    cargoDeps
    postInstall
    versionCheckProgramArg
    meta
    cargoRoot
    ;

  postPatch = ''
    substituteInPlace python/ty/__main__.py --replace-fail \
      '"""Return the ty binary path."""' 'return "${lib.getExe pkgs.ty}"'
  '';

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pyproject = true;
  pythonImportsCheck = [ "ty" ];
}
