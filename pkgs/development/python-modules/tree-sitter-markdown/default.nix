{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "tree-sitter-markdown";
  # only update to the latest version on PyPI
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-markdown";
    tag = "v${version}";
    hash = "sha256-OlVuHz9/5lxsGVT+1WhKx+7XtQiezMW1odiHGinzro8=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_markdown" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # later versions have incompatible changes, pin it to the latest on PyPI
      # reverse-dependencies also pull packages from PyPI, see:
      # https://github.com/Textualize/textual/issues/5868
      "--version=0.3.2"
    ];
  };

  meta = {
    description = "Markdown grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
    changelog = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      gepbird
    ];
  };
}
