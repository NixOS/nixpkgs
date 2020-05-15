{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestcov
, pytestrunner
, pycodestyle
, pyyaml
}:

buildPythonPackage rec {
  pname = "tinydb";
  version = "v3.14.1";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = version;
    sha256 = "02idbvrm8j4mwsjfkzy11f4png19k307p53s4qa2ifzssysxpb96";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

  checkInputs = [
    pytest
    pytestcov
    pycodestyle
    pyyaml
  ];

  meta = with lib; {
    description = "A lightweight document oriented database written in pure Python with no external dependencies";
    homepage = "https://github.com/msiemens/tinydb";
    license = licenses.asl20;                                                                                                                                                                      
    maintainers = with maintainers; [ marcus7070 ];
  };
}
