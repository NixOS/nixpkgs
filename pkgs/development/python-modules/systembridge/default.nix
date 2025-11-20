{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "systembridge";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector-py";
    tag = "v${version}";
    hash = "sha256-Ts8zPRK6S5iLnl19Y/Uz0YAh6hDeVRNBY6HsvLwdUFw=";
  };

  pythonRelaxDeps = [ "websockets" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    websockets
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "systembridge" ];

  meta = with lib; {
    description = "Python module for connecting to System Bridge";
    homepage = "https://github.com/timmo001/system-bridge-connector-py";
    changelog = "https://github.com/timmo001/system-bridge-connector-py/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
