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
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = version;
    sha256 = "sha256-oEf4GnvbQ6LY4NaNFWRmnNz1TK2tMpIVUxskhU38g4w=";
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

  meta = with lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
