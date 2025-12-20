{
  lib,
  aiofiles,
  aiohttp,
  aiolimiter,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  protobuf,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "tesla-fleet-api";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-tesla-fleet-api";
    tag = "v${version}";
    hash = "sha256-wZS/o795v5luHdSKBDnEgPeX8HQdN190UQspXJV/dQE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    aiolimiter
    bleak
    bleak-retry-connector
    cryptography
    protobuf
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tesla_fleet_api" ];

  meta = {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    changelog = "https://github.com/Teslemetry/python-tesla-fleet-api/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
