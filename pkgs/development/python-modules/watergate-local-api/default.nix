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
  version = "2025.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "watergate-ai";
    repo = "watergate-local-api-python";
    tag = version;
    hash = "sha256-px1vtWGW9JlU9ZXvmTq9YXZDmWIU0xYy3KOyamGyY74=";
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
    changelog = "https://github.com/watergate-ai/watergate-local-api-python/releases/tag/${src.tag}";
    description = "Python package to interact with the Watergate Local API";
    homepage = "https://github.com/watergate-ai/watergate-local-api-python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
