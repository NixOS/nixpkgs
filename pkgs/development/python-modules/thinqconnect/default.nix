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
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "thinq-connect";
    repo = "pythinqconnect";
    rev = "refs/tags/${version}";
    hash = "sha256-Y/L/PhTBTUF8INqLgIi1llRrticlGPb8F/sPq3XWxN4=";
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
