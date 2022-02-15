{ lib
, buildPythonApplication
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dpLtZueT5eea5qcM8s+GGRftSOr/DYrfgl5k2Fgg8lE=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # sensitive to output of other commands
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
