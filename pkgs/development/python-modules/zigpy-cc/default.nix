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
  pname = "zigpy-cc";
  version = "0.5.2";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-cc";
    rev = version;
    sha256 = "U3S8tQ3zPlexZDt5GvCd+rOv7CBVeXJJM1NGe7nRl2o=";
  };

  propagatedBuildInputs = [
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
    description = "A library which communicates with Texas Instruments CC2531 radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-cc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
