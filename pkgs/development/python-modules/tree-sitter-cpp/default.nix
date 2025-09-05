{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-cpp";
  version = "0.23.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-cpp";
    tag = "v${version}";
    hash = "sha256-tP5Tu747V8QMCEBYwOEmMQUm8OjojpJdlRmjcJTbe2k=";
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
  pythonImportsCheck = [ "tree_sitter_cpp" ];

  meta = {
    description = "C++ grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dadada ];
  };
}
