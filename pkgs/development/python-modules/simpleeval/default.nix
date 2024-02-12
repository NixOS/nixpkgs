{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "0.9.13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-I1GILYPE6OyotgRe0Ek/iHHv6q9/b/MlcTxMAtfZD80=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/danthedeckie/simpleeval/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ johbo ];
  };
}
