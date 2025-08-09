{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tree-sitter-make";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-make";
    rev = "v${version}";
    hash = "sha256-WiuhAp9JZKLd0wKCui9MV7AYFOW9dCbUp+kkVl1OEz0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-75jtur5rmG4zpNXSE3OpPVR+/lf4SICsh+kgzIKfbd4=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
  ];

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [
    "tree_sitter_make"
  ];

  meta = {
    description = "Makefile grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter-grammars/tree-sitter-make";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
