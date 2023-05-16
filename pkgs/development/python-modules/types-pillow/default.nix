{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
<<<<<<< HEAD
  version = "10.0.0.2";
=======
  version = "9.4.0.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
<<<<<<< HEAD
    hash = "sha256-/gk4CrItQSztmJoGfp7kr3Gfo6R7obU7IytGUUqHEEI=";
=======
    hash = "sha256-fw6HHS1G+7a8feyj4C3FUs+cHotJ3rlZVQlVG+OVTkk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "PIL-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Pillow";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s ];
  };
}
