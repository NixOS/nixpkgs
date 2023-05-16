{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-design";
<<<<<<< HEAD
  version = "0.5.0";

  format = "flit";

  disabled = pythonOlder "3.8";
=======
  version = "0.4.1";

  format = "flit";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
<<<<<<< HEAD
    hash = "sha256-6OUTrOpvktFcbeOzTpVEWPJFuOdhtFtjlQ9lNzNSqwA=";
=======
    hash = "sha256-W2QYukotw9g1kuoP9hpSqJH+chlaTDoYsvocdmjORwg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = with lib; {
    description = "A sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
<<<<<<< HEAD
    changelog = "https://github.com/executablebooks/sphinx-design/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
