{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unidecode";
  version = "1.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "avian2";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-2LRV6Egst2bdxefEzfuA9Ef8zMSWvmlCEV/sIzezyPw=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "unidecode"
  ];

  meta = with lib; {
    description = "ASCII transliterations of Unicode text";
    homepage = "https://pypi.python.org/pypi/Unidecode/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
