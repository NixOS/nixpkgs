{ lib
, buildPythonPackage
, fetchPypi
, nose
, setuptools
<<<<<<< HEAD
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, arrow
, requests
, units
, pint
, pydantic
, pytz
, six
}:

buildPythonPackage rec {
  pname = "stravalib";
  version = "1.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P00oxUz0oVQB969c/N2wpKLe09wtvQWPH4DH4EZUaxc=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    nose
  ];

  propagatedBuildInputs = [
    arrow
    requests
    units
    pint
    pydantic
    pytz
<<<<<<< HEAD
=======
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    six
  ];

  # tests require network access
  # testing strava api
  doCheck = false;

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/stravalib/stravalib";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
