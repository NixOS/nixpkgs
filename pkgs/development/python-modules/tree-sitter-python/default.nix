{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-python";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-python";
    tag = "v${version}";
    hash = "sha256-F5XH21PjPpbwYylgKdwD3MZ5o0amDt4xf/e5UikPcxY=";
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
  pythonImportsCheck = [ "tree_sitter_python" ];

  meta = with lib; {
    description = "Python grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-python";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
