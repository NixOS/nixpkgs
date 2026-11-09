{
  lib,
  aenum,
  aiohttp-retry,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "weheat";
  version = "2026.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wefabricate";
    repo = "wh-python";
    tag = finalAttrs.version;
    hash = "sha256-0BAzFrIxPAP99C3urGSC0IUiWjtKj5ZcDEU4O90TYRA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aenum
    aiohttp
    aiohttp-retry
    pydantic
    python-dateutil
    urllib3
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "weheat" ];

  meta = {
    description = "Library to interact with the weheat API";
    homepage = "https://github.com/wefabricate/wh-python";
    changelog = "https://github.com/wefabricate/wh-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
