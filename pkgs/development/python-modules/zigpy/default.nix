{ lib
, aiohttp
, aiosqlite
, aioresponses
, buildPythonPackage
, crccheck
, cryptography
, freezegun
, fetchFromGitHub
, jsonschema
, pycryptodome
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
}:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.63.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = "refs/tags/${version}";
    hash = "sha256-iZxHXxheyoA5vo0Pxojs7QE8rSyTpsYpJ6/OzDSZJ20=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    aiosqlite
    crccheck
    cryptography
    jsonschema
    pyserial-asyncio
    pycryptodome
    voluptuous
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # # Our two manual scans succeeded and the periodic one was attempted
    # assert len(mock_scan.mock_calls) == 3
    # AssertionError: assert 4 == 3
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
