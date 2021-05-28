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
  version = "4.1.1";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "v${version}";
    sha256 = "09cwdmpj91c6q7jympip1lrcd3idbm9cqblgvmrh0v1vy1iv2ki7";
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
