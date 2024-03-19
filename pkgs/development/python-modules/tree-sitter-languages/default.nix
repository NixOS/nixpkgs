{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, python
, pythonOlder
, setuptools
, tree-sitter
}:

buildPythonPackage rec {
  pname = "tree-sitter-languages";
  version = "1.10.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "py-tree-sitter-languages";
    rev = "refs/tags/v${version}";
    hash = "sha256-AuPK15xtLiQx6N2OATVJFecsL8k3pOagrWu1GascbwM=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    tree-sitter
  ];

  # Importing issue, check with next release
  doCheck = false;

  pythonImportsCheck = [
    "tree_sitter_languages"
  ];

  meta = with lib; {
    description = "Module for all tree sitter languages";
    homepage = "https://github.com/grantjenks/py-tree-sitter-languages";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
