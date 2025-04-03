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
  pname = "tree-sitter-yaml";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-yaml";
    tag = "v${version}";
    hash = "sha256-23/zcjnQUQt32N2EdQMzWM9srkXfQxlBvOo7FWH6rnw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-Rxjimtp5Lg0x8wgWvyyCepMJipPdc0TplxznrF9COtM=";
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
}
