{ lib
, buildPythonPackage
, fetchPypi
, pathspec
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.25.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1549cbe5b47b6ba67bdeea31720f5c51431a4d0c076c1557952d841f7223519";
  };

  propagatedBuildInputs = [
    pyyaml
    pathspec
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test failure could be related to https://github.com/adrienverge/yamllint/issues/334
    "test_find_files_recursively"
  ];

  pythonImportsCheck = [ "yamllint" ];

  meta = with lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer mikefaille ];
  };
}
