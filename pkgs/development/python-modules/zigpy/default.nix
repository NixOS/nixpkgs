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
  pytest-xdist,
  pytestCheckHook,
  serialx,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "zigpy";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    tag = finalAttrs.version;
    hash = "sha256-zmgh+ihNgQMxGoWx3zQ+UWGh04IyXCQUfGf3ybJg3Sc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'

    # do not install development tools
    rm -r tools
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
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # (Race condition) AssertionError: assert 4 == 3
    "test_periodic_scan_priority"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/ota/test_ota_image.py"
    "tests/ota/test_ota_providers.py"
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
