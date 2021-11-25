{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unidecode";
  version = "1.3.2";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "avian2";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "07789mrq0gjxrg1b9a3ypzzfww224sbj25wl0h9nik22sjwi8qhh";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "unidecode"
  ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/Unidecode/";
    description = "ASCII transliterations of Unicode text";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
