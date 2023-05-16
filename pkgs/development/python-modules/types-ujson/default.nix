{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-ujson";
<<<<<<< HEAD
  version = "5.8.0.1";
=======
  version = "5.7.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-KxQ4gkirTNH176jEZHYREll8zVfA2EI49zYxq+DiDP0=";
=======
    hash = "sha256-f/Kmd2BI5q1qvH6+39Qq4bbABVEq/7rkTK8/selrXRI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = false;

  pythonImportsCheck = [
    "ujson-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}
