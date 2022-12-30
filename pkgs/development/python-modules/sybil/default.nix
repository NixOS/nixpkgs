{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sybil";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4zlDL+Get5mGUayETMLU048tpY2/vcWdkukbYW+VfNg=";
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
