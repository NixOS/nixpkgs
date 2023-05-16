{ lib
<<<<<<< HEAD
, aenum
, buildPythonPackage
, fetchPypi
, pythonOlder
=======
, buildPythonPackage
, pythonOlder
, fetchPypi
, aenum
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, simplejson
}:

buildPythonPackage rec {
  pname = "wallbox";
<<<<<<< HEAD
  version = "0.4.14";
  format = "setuptools";
=======
  version = "0.4.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-HKlq5DPG3HD9i9LLTJdlzEFim+2hBdSfKl43BojhEf8=";
=======
    hash = "sha256-/RM1tqtGBCUa1fcqh5yvVQMNzaEqpAUPonciEIE6lC4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aenum
    requests
    simplejson
  ];

  # no tests implemented
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "wallbox"
  ];
=======
  pythonImportsCheck = [ "wallbox" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Module for interacting with Wallbox EV charger api";
    homepage = "https://github.com/cliviu74/wallbox";
<<<<<<< HEAD
    changelog = "https://github.com/cliviu74/wallbox/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
