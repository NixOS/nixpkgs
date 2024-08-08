{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  pint,
  pydantic,
  pythonOlder,
  pytz,
  requests,
  responses,
  setuptools,
  setuptools-scm,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "stravalib";
  version = "1.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    rev = "c2561b6771fa88c5f9add1cf1b9807c4b4da3171";
    owner = "stravalib";
    repo = "stravalib";
    hash = "sha256-KctJ1ARgp4RyQsaL4ytug5+YqnimB2KCVF54gBAaJoA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    poetry-core
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

  pythonImportsCheck = [ "stravalib" ];

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/stravalib/stravalib";
    changelog = "https://github.com/stravalib/stravalib/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
  };
}
