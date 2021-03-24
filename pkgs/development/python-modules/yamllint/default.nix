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
  version = "1.26.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0e4c89985c7f5f8451c2eb8c67d804d10ac13a4abe031cbf49bdf3465d01087";
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
