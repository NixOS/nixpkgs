{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioaxlevpp";
  version = "0.2.0";
  pyproject = true;
  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Herbertmt978";
    repo = "python-axle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B1jNKZtz4jQ5XPBDZ9wfHk3HEAr4t2PwMJ201cOc638=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioaxlevpp" ];

  meta = {
    description = "Asynchronous client for Axle Energy Home Assistant grid events";
    homepage = "https://github.com/Herbertmt978/python-axle";
    changelog = "https://github.com/Herbertmt978/python-axle/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
