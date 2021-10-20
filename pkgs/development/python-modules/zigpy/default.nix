{ lib
, aiohttp
, aiosqlite
, asynctest
, buildPythonPackage
, crccheck
, fetchFromGitHub
, pycryptodome
, pytest-aiohttp
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = version;
    sha256 = "sha256-3iS2VMaicbgtsiKUPe6GjFJQV8xKjs+dC8+IeprMa9I=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiosqlite
    crccheck
    pycryptodome
    voluptuous
  ];

  checkInputs = [
    pytest-aiohttp
    pytest-timeout
    pytestCheckHook
  ]  ++ lib.optionals (pythonOlder "3.8") [
    asynctest
  ];

  disabledTests = [
    # RuntimeError: coroutine 'test_remigrate_forcibly_downgraded_v4' was never awaited
    #"test_remigrate_forcibly_downgraded_v4"
    # RuntimeError: Event loop is closed
    #"test_startup"
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
