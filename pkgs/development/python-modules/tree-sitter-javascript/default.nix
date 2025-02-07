{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-javascript";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-javascript";
    tag = "v${version}";
    hash = "sha256-apgWWYD0XOvH5c3BY7kAF7UYtwPJaEvJzC5aWvJ9YQ8=";
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
