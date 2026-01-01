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
<<<<<<< HEAD
  typing-extensions,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "tesla-fleet-api";
<<<<<<< HEAD
  version = "1.2.7";
=======
  version = "1.2.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-tesla-fleet-api";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wZS/o795v5luHdSKBDnEgPeX8HQdN190UQspXJV/dQE=";
=======
    hash = "sha256-7Diq7xT8tPO4fXp7qsFXWtWExqm2vctoOtPvlCuWOKg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    typing-extensions
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tesla_fleet_api" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    changelog = "https://github.com/Teslemetry/python-tesla-fleet-api/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    changelog = "https://github.com/Teslemetry/python-tesla-fleet-api/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
