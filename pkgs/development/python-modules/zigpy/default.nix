{ lib
, aiohttp
, aiosqlite
, asynctest
, buildPythonPackage
, crccheck
, cryptography
, freezegun
, fetchFromGitHub
, pycryptodome
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.51.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = "refs/tags/${version}";
    hash = "sha256-IfYWuJfmQtJnVANyiBE3AurhucqZ8qzYXBV3jprS5qw=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiosqlite
    crccheck
    cryptography
    pyserial-asyncio
    pycryptodome
    voluptuous
  ];

  checkInputs = [
    asynctest
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
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
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
