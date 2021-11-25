{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "0.9.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = pname;
    rev = version;
    sha256 = "111w76mahbf3lm2p72dkqp5fhwg7nvnwm4l078dgsgkixssjazi7";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test_simpleeval.py"
  ];

  pythonImportsCheck = [
    "simpleeval"
  ];

  meta = with lib; {
    description = "Simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    license = licenses.mit;
    maintainers = with maintainers; [ johbo ];
  };
}
