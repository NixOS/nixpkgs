{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  wheel,
  tree-sitter,
}:

let
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-embedded-template";
    rev = "v${version}";
    hash = "sha256-C2Lo3tT2363O++ycXiR6x0y+jy2zlmhcKp7t1LhvCe8=";
  };
in
buildPythonPackage {
  pname = "tree-sitter-embedded-template";
  inherit version src;
  pyproject = true;
  disabled = pythonOlder "3.9";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-DscTKXKukh3RsqtKjplyzrxY977zUgpFpeXtFOLJEXA=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
    wheel
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [
    "tree_sitter_embedded_template"
  ];

  meta = {
    description = "Tree-sitter grammar for embedded template languages like ERB, EJS";
    homepage = "https://github.com/tree-sitter/tree-sitter-embedded-template";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
