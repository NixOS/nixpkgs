{ lib
, buildPythonApplication
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "597d71e246690b9223c132f0ed7dcac470dcbe9ad022004a801e108a00dc3524";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Will be fixed with 3.0.0, https://github.com/simplistix/sybil/pull/27
    "test_future_imports"
    "test_pytest"
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
