{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "simplepush";
  version = "2.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simplepush";
    repo = "simplepush-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/qjGJgoyI54rP+sD/Dqr1lFh8cFRboW91GYDCZgMIlM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "simplepush" ];

  meta = {
    description = "Module to send push notifications via Simplepush";
    homepage = "https://github.com/simplepush/simplepush-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
