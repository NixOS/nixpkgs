{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.13.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = pname;
    rev = version;
    hash = "sha256-kq3Ujkn4HzonzjuQfVnPNnQV+2Rnbr3ZfYmrnY3upxU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "wrapt"
  ];

  meta = with lib; {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
