{
  lib,
  aiohttp,
  awsiotsdk,
  buildPythonPackage,
  fetchFromGitHub,
  pyopenssl,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thinqconnect";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "thinq-connect";
    repo = "pythinqconnect";
    tag = version;
    hash = "sha256-LVmvJvGbiPPg+WlrTOYueNCNZNjldWJVC+OqFl9CcK0=";
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
