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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-yaml";
    rev = "v${version}";
    hash = "sha256-23/zcjnQUQt32N2EdQMzWM9srkXfQxlBvOo7FWH6rnw=";
  };
in
buildPythonPackage {
  pname = "tree-sitter-yaml";
  inherit version src;
  pyproject = true;
  disabled = pythonOlder "3.9";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-Rxjimtp5Lg0x8wgWvyyCepMJipPdc0TplxznrF9COtM=";
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
    "tree_sitter_yaml"
  ];

  meta = {
    description = "YAML grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter-grammars/tree-sitter-yaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
