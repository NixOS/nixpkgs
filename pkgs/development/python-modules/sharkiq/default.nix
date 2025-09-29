{
  lib,
  aiohttp,
  auth0-python,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sharkiq";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeffResc";
    repo = "sharkiq";
    tag = "v${version}";
    hash = "sha256-XPqrEE/GwIn4sqbhETRPhBBPkH8Je+LKoDV+qDb3Ry8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    auth0-python
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sharkiq" ];

  meta = {
    description = "Python API for Shark IQ robots";
    homepage = "https://github.com/JeffResc/sharkiq";
    changelog = "https://github.com/JeffResc/sharkiq/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
