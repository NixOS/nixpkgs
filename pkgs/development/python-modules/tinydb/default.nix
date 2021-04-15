{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry
, pytestCheckHook
, pytestcov
, pytestrunner
, pycodestyle
, pyyaml
}:

buildPythonPackage rec {
  pname = "tinydb";
  version = "4.4.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z5gnffizgbyhh20jy63bkkjh20ih8d62kcfhiaqa6rvnnffqmnw";
  };

  nativeBuildInputs = [ poetry ];

  checkInputs = [
    pytestCheckHook
    pytestcov
    pycodestyle
    pyyaml
  ];

  meta = with lib; {
    description = "A lightweight document oriented database written in pure Python with no external dependencies";
    homepage = "https://tinydb.readthedocs.org/";
    changelog = "https://tinydb.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ marcus7070 ];
  };
}
