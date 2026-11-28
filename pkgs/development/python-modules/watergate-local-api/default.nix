{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "watergate-local-api";
  version = "2026.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "watergate-ai";
    repo = "watergate-local-api-python";
    tag = version;
    hash = "sha256-niK9lJQ7YX/HJsyurbQra3H7O8mrnjfPH7uuet/MqF8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
