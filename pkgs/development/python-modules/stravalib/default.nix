{ lib
, buildPythonPackage
, fetchPypi
, nose
, setuptools
, setuptools-scm
, wheel
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
  version = "1.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OEdMRg3KjUrXt/CgJgsUqa/sVFAE0JONNZg5MBKtxmY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

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
    six
  ];

  # tests require network access
  # testing strava api
  doCheck = false;

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/stravalib/stravalib";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
