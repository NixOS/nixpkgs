{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  nix-update-script,

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

  # No tests in the pypi archive, we add a test to check that all bindings can be imported
  checkPhase = ''
    runHook preCheck

    cat <<EOF > test-import-bindings.py
    import sys
    import os
    if (cwd := os.getcwd()) in sys.path:
      # remove current working directory from sys.path, use PYTHONPATH instead
      sys.path.remove(cwd)

    from typing import get_args
    from tree_sitter_language_pack import SupportedLanguage, get_binding

    for lang in get_args(SupportedLanguage):
      get_binding(lang)
    EOF

    ${python.interpreter} test-import-bindings.py

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Comprehensive collection of tree-sitter languages";
    homepage = "https://github.com/Goldziher/tree-sitter-language-pack";
    changelog = "https://github.com/Goldziher/tree-sitter-language-pack/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
