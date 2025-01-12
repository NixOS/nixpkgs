{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-rust";
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-rust";
    tag = "v${version}";
    hash = "sha256-aT+tlrEKMgWqTEq/NHh8Vj92h6i1aU6uPikDyaP2vfc=";
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
  pythonImportsCheck = [ "tree_sitter_rust" ];

  meta = with lib; {
    description = "Rust grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
