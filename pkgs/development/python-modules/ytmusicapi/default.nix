{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "sigma67";
    repo = "ytmusicapi";
    rev = "refs/tags/${version}";
    hash = "sha256-YgV3kCvCOLNXb3cWBVXRuzH4guuvPpXVojOnSnrXj20=";
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-95i/7dSXOL7OgqrBWy2X8EV4zLFXLzR6NQy3BN9NDhA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

<<<<<<< HEAD
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # requires network access

  pythonImportsCheck = [
    "ytmusicapi"
  ];

  meta = with lib; {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    changelog = "https://github.com/sigma67/ytmusicapi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
