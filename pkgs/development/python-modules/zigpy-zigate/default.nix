{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pyusb
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy }:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.7.4";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-zigate";
    rev = version;
    sha256 = "0xl8qgljvmypi602f52m89iv9pcrzsdal3jw619vrcavp40rc04d";
  };

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
    pyusb
    zigpy
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A library which communicates with ZiGate radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-zigate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
