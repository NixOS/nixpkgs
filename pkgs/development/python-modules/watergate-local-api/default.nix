{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "watergate-local-api";
  version = "2024.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "watergate-ai";
    repo = "watergate-local-api-python";
    tag = version;
    hash = "sha256-zEbujtXTXjRRzpNdowh7xjBvCxwp7Z1QYRm6ZM8rFR8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "watergate_local_api" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Python package to interact with the Watergate Local API";
    homepage = "https://github.com/watergate-ai/watergate-local-api-python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
