{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  cython,
  setuptools,
  typing-extensions,
  tree-sitter,
  tree-sitter-c-sharp,
  tree-sitter-embedded-template,
  tree-sitter-yaml,
}:

let
  version = "0.6.1";
in
buildPythonPackage {
  pname = "tree-sitter-language-pack";
  inherit version;
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tree_sitter_language_pack";
    inherit version;
    hash = "sha256-pGNfW2ubZCVi2QHk6qJfyClJ1mDIi5R1Pm1GfZY0Ark=";
  };

  build-system = [
    cython
    setuptools
    typing-extensions
  ];

  dependencies = [
    tree-sitter
    tree-sitter-c-sharp
    tree-sitter-embedded-template
    tree-sitter-yaml
  ];

  pythonImportsCheck = [
    "tree_sitter_language_pack"
    "tree_sitter_language_pack.bindings"
  ];

  meta = {
    description = "Comprehensive collection of tree-sitter languages";
    homepage = "https://github.com/Goldziher/tree-sitter-language-pack/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
