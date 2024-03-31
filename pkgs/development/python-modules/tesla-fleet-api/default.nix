{ lib
, aiohttp
, aiolimiter
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "tesla-fleet-api";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-tesla-fleet-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-rVxrMgp1V8wlDE+PGGiyZbpe4OuU2LT/LFYQ6m6k98o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    aiolimiter
  ];

  # Module has no tests
  doCheck  =false;

  pythonImportsCheck = [
    "tesla_fleet_api"
  ];

  meta = with lib; {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    changelog = "https://github.com/Teslemetry/python-tesla-fleet-api/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
