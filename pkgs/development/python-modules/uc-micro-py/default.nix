{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "uc-micro-py";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "uc.micro-py";
    rev = "v${version}";
    hash = "sha256-23mKwoRGjtxpCOC26V8bAN5QEHLDOoSqPeTlUuIrxZ0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "uc_micro" ];

  meta = with lib; {
    description = "Micro subset of unicode data files for linkify-it-py";
    homepage = "https://github.com/tsutsu3/uc.micro-py";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
