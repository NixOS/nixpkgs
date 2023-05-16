{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# tests
, ipykernel
, nbconvert
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "wasabi";
<<<<<<< HEAD
  version = "1.1.2";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Gq7zrOqjLtuckTMNKdOTbAw5/blldDVJwXPLVLFsMLU=";
=======
    hash = "sha256-9e58YJAngRvRbmIPL9enMZRmAFhI5BsFGmIFOrj9cNY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    ipykernel
    nbconvert
    typing-extensions
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "wasabi"
  ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
