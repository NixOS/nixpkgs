{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "uc-micro-py";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "uc.micro-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-PUeWYG/VyxCfhB7onAcDFow1yYqArjmfMT99+058P7U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "uc_micro"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Micro subset of unicode data files for linkify-it-py";
    homepage = "https://github.com/tsutsu3/uc.micro-py";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
