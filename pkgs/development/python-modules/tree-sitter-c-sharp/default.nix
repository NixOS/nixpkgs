{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  rustc,
  setuptools,
  tree-sitter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tree-sitter-c-sharp";
  version = "0.23.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-c-sharp";
    tag = "v${version}";
    hash = "sha256-N5AAlwQFGGi47cj0m7Te08bA486gwY6NBOx4Qcy4lpo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-fPjCguwWE+beoOiLR2EyMtogiv1JRXI8NP4vCuvGHss=";
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

  pythonImportsCheck = [ "tree_sitter_c_sharp" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  meta = {
    description = "C# Grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-c-sharp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
