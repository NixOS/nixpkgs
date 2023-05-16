{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
<<<<<<< HEAD
  version = "0.26";
=======
  version = "0.25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-rbM5fVywYTYyzT2teJQ4FCK6wkRkw5PLBQQE3WcSsac=";
=======
    hash = "sha256-j95THZLRz8KBf+Nkez8tB+dmgsSoSInASlPoMffFRDI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sphinx
    plantuml
  ];

  # No tests included.
  doCheck = false;

  meta = with lib; {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = "https://github.com/sphinx-contrib/plantuml/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ ];
  };
}
