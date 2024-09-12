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
  pname = "pythinqconnect";
  version = "0.9.7-unstable-2024-09-09";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "thinq-connect";
    repo = "pythinqconnect";
    # https://github.com/thinq-connect/pythinqconnect/issues/1
    rev = "39d535a2a5d1067a110eea37ae92002d0793b7e9";
    hash = "sha256-+nQAUqg5rB2eJgPBJJR8NsQ1O2Wb4UsbBQVPir1jyAU=";
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
    description = "Module to interacting with the LG ThinQ Connect Open API";
    homepage = "https://github.com/thinq-connect/pythinqconnect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
