{
  lib,
  stdenv,
  aiohttp,
  aioresponses,
  aiosqlite,
  async-timeout,
  attrs,
  buildPythonPackage,
  crccheck,
  cryptography,
  fetchFromGitHub,
  freezegun,
  frozendict,
  jsonschema,
  pyserial-asyncio-fast,
  pytest-asyncio_0,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "zigpy";
<<<<<<< HEAD
  version = "0.88.0";
=======
  version = "0.86.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jYhanzekQIIBSqoB/8sToKOhAS/Cicx5OJ83XxWTp7E=";
=======
    hash = "sha256-PROJKC8ZxAZ8zZR4if33553qtp7i9y58LPr1d1gCXVQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio_0
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # assert quirked.quirk_metadata.quirk_location.endswith("zigpy/tests/test_quirks_v2.py]-line:104") is False
    "test_quirks_v2"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    "test_periodic_scan_priority"
  ];

  disabledTestPaths = [
    # Tests require network access
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

<<<<<<< HEAD
  meta = {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    changelog = "https://github.com/zigpy/zigpy/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    changelog = "https://github.com/zigpy/zigpy/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
