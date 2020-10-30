{ lib
, aiohttp
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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = version;
    sha256 = "ba8Ru6RCbFOHhctFtklnrxVD3uEpxF4XDvO5RMgXPBs=";
  };

  propagatedBuildInputs = [
    aiohttp
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
