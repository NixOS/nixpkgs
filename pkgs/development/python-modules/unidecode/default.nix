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
    sha256 = "sha256-IY/be5052KmCXcpbU1s/SK8JxwYin4YX571cTTNbd/8=";
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
