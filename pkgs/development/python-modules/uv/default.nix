{
  buildPythonPackage,
  installShellFiles,
  pkg-config,
  rustPlatform,
  pkgs,
}:

buildPythonPackage {
  inherit (pkgs.uv)
    pname
    version
    src
    cargoDeps
    dontUseCmakeConfigure
    meta
    cargoBuildFlags
    postInstall
    versionCheckProgramArg
    ;

  nativeBuildInputs = [
    pkgs.cmake
    installShellFiles
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pyproject = true;
  pythonImportsCheck = [ "uv" ];
}
