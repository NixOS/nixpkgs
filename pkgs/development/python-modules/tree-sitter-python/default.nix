{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, tree-sitter
}:

buildPythonPackage rec {
  pname = "tree-sitter-python";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-python";
    rev = "v${version}";
    hash = "sha256-ZQ949GbgzZ/W667J+ekvQbs4bGnbDO+IWejivhxPZXM=";
  };

  build-system = [
    setuptools
  ];

  passthru.optional-dependencies = {
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
