{ lib, buildPythonPackage, fetchFromGitHub, elementpath, lxml, pytestCheckHook
, pythonOlder }:

buildPythonPackage rec {
  version = "1.8.2";
  pname = "xmlschema";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "sha256-d7f19T17aAwdtNDjCrsXXY39u0aRgQo4vFPnxFNs2PQ=";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ lxml pytestCheckHook ];

  # Ignore broken fixtures, and tests for files which don't exist.
  # For darwin, we need to explicity say we can't reach network
  disabledTests = [ "export_remote" "element_tree_import_script" ];

  disabledTestPaths = [
    "tests/test_schemas.py"
    "tests/test_memory.py"
    "tests/test_validation.py"
  ];

  pythonImportsCheck = [ "xmlschema" ];

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
