{
  lib,
  stdenv,
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
  pyserial-asyncio-fast,
  pytest-asyncio_0,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.92.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    tag = version;
    hash = "sha256-6rbjv91mkTSEAKndDy/2a8bGpzw/5g57FEZvZdt9ARI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
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
    pyserial-asyncio-fast
    typing-extensions
    voluptuous
  ];

  nativeCheckInputs = [
    aioresponses
    filelock
    freezegun
    pytest-asyncio_0
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
    changelog = "https://github.com/zigpy/zigpy/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
}
