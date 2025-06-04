{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-json";
  version = "0.24.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-json";
    tag = "v${version}";
    hash = "sha256-DNZC2cTy1C8OaMOpEHM6NoRtOIbLaBf0CLXXWCKODlw=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [ "tree_sitter_json" ];

  meta = with lib; {
    description = "JSON grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-json";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
