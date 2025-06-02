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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tesla-fleet-api";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-tesla-fleet-api";
    tag = "v${version}";
    hash = "sha256-ykVes0LXvkwdZRX9g1N9WqzDgKzR5u/YLKkdMC9lR64=";
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
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tesla_fleet_api" ];

  meta = with lib; {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
