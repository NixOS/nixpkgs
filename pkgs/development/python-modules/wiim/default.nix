{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  async-upnp-client,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "wiim";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Linkplay2020";
    repo = "wiim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WJbnVJ7ZM4wZk3Y8zTRc3i24CyTA8Wz9EKYr5BNlx6o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-upnp-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
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
