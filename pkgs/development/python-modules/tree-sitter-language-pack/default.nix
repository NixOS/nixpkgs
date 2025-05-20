{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  setuptools,
  typing-extensions,

  # dependencies
  tree-sitter,
  tree-sitter-c-sharp,
  tree-sitter-embedded-template,
  tree-sitter-yaml,
}:

buildPythonPackage rec {
  pname = "tree-sitter-language-pack";
  version = "0.7.3";
  pyproject = true;

  # Using the GitHub sources necessitates fetching the treesitter grammar parsers by using a vendored script:
  # https://github.com/Goldziher/tree-sitter-language-pack/blob/main/scripts/clone_vendors.py
  # The pypi archive has the benefit of already vendoring those dependencies which makes packaging easier on our side
  src = fetchPypi {
    pname = "tree_sitter_language_pack";
    inherit version;
    hash = "sha256-SROctgfYE1LTOtGOV1IPwQV6AJlVyczO1WYHzBjmo/0=";
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

  prePatch = ''
    # Remove the packaged bindings, which only work on Linux and prevent the build from succeeding
    # https://github.com/Goldziher/tree-sitter-language-pack/issues/46
    rm -rf tree_sitter_language_pack/bindings/*.so
  '';

  pythonImportsCheck = [
    "tree_sitter_language_pack"
    "tree_sitter_language_pack.bindings"
  ];

  # No tests in the pypi archive
  doCheck = false;

  meta = {
    description = "Comprehensive collection of tree-sitter languages";
    homepage = "https://github.com/Goldziher/tree-sitter-language-pack";
    changelog = "https://github.com/Goldziher/tree-sitter-language-pack/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
