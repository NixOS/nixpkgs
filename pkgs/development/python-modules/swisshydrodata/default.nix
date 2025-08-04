{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  requests-mock,
  requests,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "swisshydrodata";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "swisshydrodata";
    tag = version;
    hash = "sha256-Yy/sc/SKKftIsZLyIJabrgcgYwbBxZMXbhTaWSIKpM8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    requests-mock
  ];

  pythonImportsCheck = [ "swisshydrodata" ];

  meta = {
    description = "Python client to get data from the Swiss federal Office for Environment FEON";
    homepage = "https://github.com/bouni/swisshydrodata";
    changelog = "https://github.com/Bouni/swisshydrodata/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
