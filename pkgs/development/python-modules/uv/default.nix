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

  postPatch = ''
    substituteInPlace python/uv/_find_uv.py \
      --replace-fail '"""Return the uv binary path."""' "return '$out/bin/uv'"
  '';

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
