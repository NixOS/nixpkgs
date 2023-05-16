{ lib
, buildPythonPackage
, fetchPypi
, click
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
<<<<<<< HEAD
  version = "2.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/eVFa1BTFbvFTAt48Bv+bjsV7f2eVSuKARJQVxDqU9s=";
=======
  version = "2.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D6Q76L1BVx5hpFSShP1rUOmgTogEO+6Jj5x8GaepC+c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    click
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "verisure"
  ];

  meta = with lib; {
    description = "Python library for working with verisure devices";
    homepage = "https://github.com/persandstrom/python-verisure";
<<<<<<< HEAD
    changelog = "https://github.com/persandstrom/python-verisure#version-history";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
