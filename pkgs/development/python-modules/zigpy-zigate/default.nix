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
  version = "0.7.3";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-zigate";
    rev = version;
    sha256 = "068v8n8yimmpnwqcdz5m9g35z1x0dir478cbc1s1nyhw1xn50vg1";
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
