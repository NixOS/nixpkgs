{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "volkszaehler";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-volkszaehler";
    tag = finalAttrs.version;
    hash = "sha256-DgsP3ol6VcOnoUJF1eQjNWR45SokElNosyfgvPZVihU=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "volkszaehler" ];

  meta = {
    description = "Python module for interacting with the Volkszahler API";
    homepage = "https://github.com/home-assistant-ecosystem/python-volkszaehler";
    changelog = "https://github.com/home-assistant-ecosystem/python-volkszaehler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
