{
  buildPythonPackage,
  installShellFiles,
  lib,
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
    cat > python/uv/_find_uv.py <<EOF
    from __future__ import annotations


    def find_uv_bin() -> str:
        """Return the uv binary path."""
        return "$out/bin/uv"
    EOF
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
