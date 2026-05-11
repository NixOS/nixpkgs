{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  async-upnp-client,
  zeroconf,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "wiim";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Linkplay2020";
    repo = "wiim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-buFGfM/qgZGjE3asv/5GBD4TfHj3lf/9Q9u/W9bOq3A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-upnp-client
    zeroconf
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # ValueError: Device u is not managed by the controller
    "test_async_join_group"
  ];

  pythonImportsCheck = [ "wiim" ];

  meta = {
    description = "Python-based API interface for controlling and communicating with WiiM audio devices";
    homepage = "https://github.com/Linkplay2020/wiim";
    changelog = "https://github.com/Linkplay2020/wiim/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
