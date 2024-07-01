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
}:

buildPythonPackage rec {
  pname = "stravalib";
  version = "1.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "stravalib";
    repo = "stravalib";
    rev = "refs/tags/v${version}";
    hash = "sha256-U+QlSrijvT77/m+yjhFxbcVTQe51J+PR4Kc8N+qG+wI=";
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

  pythonImportsCheck = [ "stravalib" ];

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/stravalib/stravalib";
    changelog = "https://github.com/stravalib/stravalib/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    broken = lib.versionAtLeast pydantic.version "2";
  };
}
