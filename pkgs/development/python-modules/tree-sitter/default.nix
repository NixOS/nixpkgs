{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.20.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "tree_sitter";
    inherit version;
    hash = "sha256-CmwGq6pV3hdCQaR2tTYXO7ooJB0uqF0ZjTOqi/AJ8Cg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # PyPI tarball doesn't contains tests and source has additional requirements
  doCheck = false;

  pythonImportsCheck = [
    "tree_sitter"
  ];

  meta = with lib; {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
