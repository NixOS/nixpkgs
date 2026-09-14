{
  lib,
  aiohttp,
  awsiotsdk,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thinqconnect";
  version = "1.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thinq-connect";
    repo = "pythinqconnect";
    tag = version;
    hash = "sha256-WF2Ci0a4HZpbMgMgtLfeCNZzg+C5qT+WOkAdQ7TXhkE=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    awsiotsdk
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "thinqconnect" ];

  meta = {
    description = "Module to interacting with the LG ThinQ Connect Open API";
    homepage = "https://github.com/thinq-connect/pythinqconnect";
    changelog = "https://github.com/thinq-connect/pythinqconnect/blob/${src.tag}/RELEASE_NOTES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
