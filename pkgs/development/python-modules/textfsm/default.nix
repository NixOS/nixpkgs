{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "textfsm";
  version = "1.1.3";
  format = "setuptools";


  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IHgKG8v0X+LSK6purWBdwDnI/BCs5XA12ZJixuqqXWg=";
  };

  propagatedBuildInputs = [
    six
    future
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python module for parsing semi-structured text into python tables";
    homepage = "https://github.com/google/textfsm";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
