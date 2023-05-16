{ lib
, fetchPypi
, buildPythonPackage
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "todoist-python";
<<<<<<< HEAD
  version = "8.1.4";
=======
  version = "8.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Rkg6eSLiQe8DZaVu2DEnlKLe8RLkRwKmpw+TaYj+lp0=";
=======
    hash = "sha256-AFRKA5VRD6jyiguZYP7WOQOWqHq1GjUzbuez0f1070U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "todoist"
  ];

  meta = with lib; {
    description = "The official Todoist Python API library";
    homepage = "https://todoist-python.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
