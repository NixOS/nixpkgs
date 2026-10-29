{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pycryptodome,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "switchbot-api";
  version = "2.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SeraphicCorp";
    repo = "py-switchbot-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xgfFpylMS8Xs3erM7vuJKun6fYOtJ6kfXgBVSkejbJI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pycryptodome
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "switchbot_api" ];

  meta = {
    description = "Asynchronous library to use Switchbot API";
    homepage = "https://github.com/SeraphicCorp/py-switchbot-api";
    changelog = "https://github.com/SeraphicCorp/py-switchbot-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
