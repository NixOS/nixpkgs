{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "tlds";
<<<<<<< HEAD
  version = "2023080900";
=======
  version = "2023050900";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-n6SGOBkwGrjnH01yFd9giODUDkPGVMwB1H/fozzwQwU=";
=======
    hash = "sha256-Fm2cRhUb1Gsr7mrcym/JjYAeG8f3RDhUnxzYIvpxmQE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonImportsCheck = [
    "tlds"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/mweinelt/tlds";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
