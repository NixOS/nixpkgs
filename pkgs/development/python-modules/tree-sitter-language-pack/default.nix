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
  version = "0.8.0";
  pyproject = true;

  # Using the GitHub sources necessitates fetching the treesitter grammar parsers by using a vendored script.
  # The pypi archive has the benefit of already vendoring those dependencies which makes packaging easier on our side
  # See: https://github.com/Goldziher/tree-sitter-language-pack/blob/main/scripts/clone_vendors.py
  src = fetchPypi {
    pname = "tree_sitter_language_pack";
    inherit version;
    hash = "sha256-Sar+Mi61nvTURXV3IQ+yDBjFU1saQrjnU6ppntO/nu0=";
  };

  # Upstream bumped the setuptools and typing-extensions dependencies, but we can still use older versions
  # since the newer ones aren’t packaged in nixpkgs. We can't use pythonRelaxDepsHook here because it runs
  # in postBuild, while the dependency check occurs during the build phase.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=80.9.0" "setuptools>=78.1.0" \
      --replace-fail "typing-extensions>=4.14.0" "typing-extensions>=4.13.2"
  '';

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tree_sitter_language_pack"
    "tree_sitter_language_pack.bindings"
  ];

  preCheck = ''
    # make sure import the built version, not the source one
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
