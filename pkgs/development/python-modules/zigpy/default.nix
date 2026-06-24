{
  lib,
  aiohttp,
  aioresponses,
  aiosqlite,
  attrs,
  buildPythonPackage,
  crccheck,
  cryptography,
  fetchFromGitHub,
  filelock,
  freezegun,
  frozendict,
  jsonschema,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  serialx,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "zigpy";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    tag = finalAttrs.version;
    hash = "sha256-IVFoXFeciBvENjLAT8Dztv+Unt7/WzuUH6rqF+1gy4k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    attrs
    aiohttp
    aiosqlite
    crccheck
    cryptography
    frozendict
    jsonschema
    serialx
    typing-extensions
    voluptuous
  ];

  nativeCheckInputs = [
    aioresponses
    filelock
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # assert quirked.quirk_metadata.quirk_location.endswith("zigpy/tests/test_quirks_v2.py]-line:104") is False
    "test_quirks_v2"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/ota/test_ota_image.py"
    "tests/ota/test_ota_providers.py"
    # All tests fail to shutdown thread during teardown
    "tests/ota/test_ota_matching.py"
  ];

  pythonImportsCheck = [
    "zigpy.application"
    "zigpy.config"
    "zigpy.exceptions"
    "zigpy.types"
    "zigpy.zcl"
  ];

  meta = {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    changelog = "https://github.com/zigpy/zigpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
})
