{ lib
, buildPythonPackage
, fetchFromGitHub
, elementpath
, lxml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xmlschema";
  version = "1.11.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "refs/tags/v${version}";
    hash = "sha256-z6VgLRDp5PHaYstdV30gt6xGVd4uifz4LkYQ2z3ayk4=";
  };

  propagatedBuildInputs = [
    elementpath
  ];

  checkInputs = [
    lxml
    pytestCheckHook
  ];

  # Ignore broken fixtures, and tests for files which don't exist.
  # For darwin, we need to explicity say we can't reach network
  disabledTests = [
    "export_remote"
    "element_tree_import_script"
  ];

  disabledTestPaths = [
    "tests/test_schemas.py"
    "tests/test_memory.py"
    "tests/test_validation.py"
  ];

  pythonImportsCheck = [
    "xmlschema"
  ];

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
