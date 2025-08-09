{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  setuptools,
  tree-sitter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tree-sitter-embedded-template";
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-embedded-template";
    tag = "v${version}";
    hash = "sha256-C2Lo3tT2363O++ycXiR6x0y+jy2zlmhcKp7t1LhvCe8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-DscTKXKukh3RsqtKjplyzrxY977zUgpFpeXtFOLJEXA=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_embedded_template" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  meta = {
    description = "Tree-sitter grammar for embedded template languages like ERB, EJS";
    homepage = "https://github.com/tree-sitter/tree-sitter-embedded-template";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
