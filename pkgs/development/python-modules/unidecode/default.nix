{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unidecode";
  version = "1.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "avian2";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-75E2OlrGIxvwR9MeZEB4bDLdFd1SdprCVcBIJCPS3hM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "unidecode"
  ];

  meta = with lib; {
    description = "ASCII transliterations of Unicode text";
    homepage = "https://github.com/avian2/unidecode";
    changelog = "https://github.com/avian2/unidecode/blob/unidecode-${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
