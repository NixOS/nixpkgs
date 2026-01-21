{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
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
  version = "0.13.0";
  pyproject = true;

  # Using the GitHub sources necessitates fetching the treesitter grammar parsers by using a vendored script.
  # The pypi archive has the benefit of already vendoring those dependencies which makes packaging easier on our side
  # See: https://github.com/Goldziher/tree-sitter-language-pack/blob/main/scripts/clone_vendors.py
  src = fetchPypi {
    pname = "tree_sitter_language_pack";
    inherit version;
    hash = "sha256-AyA0xeJ7H24AcwuefC28ggO0cA0MaB/QGdbe/PYRg+w=";
  };

  # Upstream bumped dependencies aggressively, but we can still use older
  # versions since the newer ones aren’t packaged in nixpkgs. We can't use
  # pythonRelaxDepsHook here because it runs in postBuild, while the dependency
  # check occurs during the build phase.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "typing-extensions>=4.15.0" "typing-extensions>=4.14.1"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

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

  pythonRelaxDeps = [
    "tree-sitter"
    "tree-sitter-embedded-template"
    "tree-sitter-yaml"
  ];

  pythonImportsCheck = [
    "tree_sitter_language_pack"
    "tree_sitter_language_pack.bindings"
  ];

  # make sure import the built version, not the source one
  preCheck = ''
    rm -r tree_sitter_language_pack
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
