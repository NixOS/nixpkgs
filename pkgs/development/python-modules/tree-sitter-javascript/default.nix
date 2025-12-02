{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-javascript";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-javascript";
    tag = "v${version}";
    hash = "sha256-2Jj/SUG+k8lHlGSuPZvHjJojvQFgDiZHZzH8xLu7suE=";
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
