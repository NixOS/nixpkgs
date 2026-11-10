{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tree-sitter-bash";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-bash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ONQ1Ljk3aRWjElSWD2crCFZraZoRj3b3/VELz1789GE=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_bash" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  meta = {
    description = "Bash grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-bash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
