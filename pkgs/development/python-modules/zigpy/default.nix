{ lib
, aiohttp
, aiosqlite
, asynctest
, buildPythonPackage
, crccheck
, fetchFromGitHub
, pycrypto
, pycryptodome
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, tox
, voluptuous }:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = version;
    sha256 = "sha256-p0q0wGp3NaBO7gBTsPAt7FEAHW0MDPJCKqLklY21zBQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiosqlite
    crccheck
    pycrypto
    pycryptodome
    voluptuous
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: coroutine 'test_remigrate_forcibly_downgraded_v4' was never awaited
    "test_remigrate_forcibly_downgraded_v4"
    # RuntimeError: Event loop is closed
    "test_startup"
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
