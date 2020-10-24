{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy }:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.6.2";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-zigate";
    rev = version;
    sha256 = "EV6DV+BytUcPMtzYVKDnq/Uv2efg3stjL5uVlL62II4=";
  };

  buildInputs = [
    pyserial
    pyserial-asyncio
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
