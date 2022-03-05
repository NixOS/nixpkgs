{ lib
, buildPythonApplication
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bwLcIgSvflohIDeSTZdPcngfbcGP08RMx85GOhIPUw0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Sensitive to output of other commands
    "test_namespace"
    "test_unittest"
  ];

  pythonImportsCheck = [
    "sybil"
  ];

  meta = with lib; {
    description = "Automated testing for the examples in your documentation";
    homepage = "https://github.com/cjw296/sybil";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
