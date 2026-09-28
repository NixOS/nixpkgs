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
  version = "2026.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "watergate-ai";
    repo = "watergate-local-api-python";
    tag = version;
    hash = "sha256-0iAxK2l9zNiVTn1FlYSq7EY9Ak2AImeYqtslrfu8qOc=";
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
