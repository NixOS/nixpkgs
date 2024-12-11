{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-javascript";
  version = "0.21.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-javascript";
    rev = "v${version}";
    hash = "sha256-jsdY9Pd9WqZuBYtk088mx1bRQadC6D2/tGGVY+ZZ0J4=";
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
  pythonImportsCheck = [ "tree_sitter_javascript" ];

  meta = with lib; {
    description = "JavaScript and JSX grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-javascript";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
