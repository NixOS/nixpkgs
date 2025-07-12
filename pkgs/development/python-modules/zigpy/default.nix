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
  pyserial-asyncio,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.80.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    tag = version;
    hash = "sha256-OHwX2bwM6XYPGs2n7X5OQ3lW1lsD0RaaPNSFXOX+C/Q=";
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
    pyserial-asyncio
    typing-extensions
    voluptuous
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests =
    [
      # assert quirked.quirk_metadata.quirk_location.endswith("zigpy/tests/test_quirks_v2.py]-line:104") is False
      "test_quirks_v2"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
      "test_periodic_scan_priority"
    ];

  disabledTestPaths = [
    # Tests require network access
    "tests/ota/test_ota_providers.py"
  ];

  pythonImportsCheck = [
    "zigpy.application"
    "zigpy.config"
    "zigpy.exceptions"
    "zigpy.types"
    "zigpy.zcl"
  ];

  meta = with lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    changelog = "https://github.com/zigpy/zigpy/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
