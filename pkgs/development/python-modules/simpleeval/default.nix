{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "0.9.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = pname;
    rev = version;
    sha256 = "0khgl729q5133fgc00d550f4r77707rkkn7r56az4v8bvx0q8xp4";
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
