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

buildPythonPackage (finalAttrs: {
  pname = "tree-sitter-yaml";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-yaml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BX6TOfAZLW+0h2TNsgsLC9K2lfirraCWlBN2vCKiXQ4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-mrLuGmauboKHHk0zADPXpwgZfc83syXk0jmD93Y9Jq4=";
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

  pythonImportsCheck = [ "tree_sitter_yaml" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  meta = {
    description = "YAML grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter-grammars/tree-sitter-yaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})
