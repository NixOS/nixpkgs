{ lib
, arrow
, buildPythonPackage
, fetchPypi
, pint
, pydantic
, pythonOlder
, pytz
, requests
, responses
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "stravalib";
  version = "1.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OEdMRg3KjUrXt/CgJgsUqa/sVFAE0JONNZg5MBKtxmY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    arrow
    pint
    pydantic
    pytz
    requests
    responses
  ];

  # Tests require network access, testing strava API
  doCheck = false;

  pythonImportsCheck = [
    "stravalib"
  ];

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/stravalib/stravalib";
    changelog = "https://github.com/stravalib/stravalib/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    # Support for pydantic > 2, https://github.com/stravalib/stravalib/issues/379
    broken = versionAtLeast pydantic.version "2";
  };
}
