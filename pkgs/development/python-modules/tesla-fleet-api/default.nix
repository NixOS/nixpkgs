{
  lib,
  aiofiles,
  aiohttp,
  aiolimiter,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  protobuf,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tesla-fleet-api";
  version = "0.9.12";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-tesla-fleet-api";
    tag = "v${version}";
    hash = "sha256-1ir1x/uvcVoad82KaGAMm/S52MT7E5SkiTnUH2cWV34=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    aiolimiter
    cryptography
    protobuf
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tesla_fleet_api" ];

  meta = with lib; {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    changelog = "https://github.com/Teslemetry/python-tesla-fleet-api/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
