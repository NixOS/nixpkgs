{
  lib,
  aiohttp,
  awsiotsdk,
  buildPythonPackage,
  fetchFromGitHub,
  pyopenssl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thinqconnect";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thinq-connect";
    repo = "pythinqconnect";
    tag = version;
    hash = "sha256-O7jH6zpwNTZM9b7XRkNNVG2tjWsOD+GvOcDrcPkmugs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    awsiotsdk
    pyopenssl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "thinqconnect" ];

  meta = {
    changelog = "https://github.com/thinq-connect/pythinqconnect/blob/${src.tag}/RELEASE_NOTES.md";
    description = "Module to interacting with the LG ThinQ Connect Open API";
    homepage = "https://github.com/thinq-connect/pythinqconnect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
