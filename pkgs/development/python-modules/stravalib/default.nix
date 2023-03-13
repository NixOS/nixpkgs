{ lib
, buildPythonPackage
, fetchPypi
, nose
, setuptools
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
    sha256 = "sha256-P00oxUz0oVQB969c/N2wpKLe09wtvQWPH4DH4EZUaxc=";
  };

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
    setuptools
    six
  ];

  # tests require network access
  # testing strava api
  doCheck = false;

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/stravalib/stravalib";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
