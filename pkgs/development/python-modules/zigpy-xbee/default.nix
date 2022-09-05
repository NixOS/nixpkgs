{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-xbee";
  version = "0.15.0";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-xbee";
    rev = version;
    sha256 = "sha256-NT7d5JWaVZOrk32uYh0z0sI9RA4eJYYIa2D/Ei81KjY=";
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

  disabledTests = [
    # assertion failure
    # E       assert ff:ff:ff:ff:ff:ff:ff:ff is None
    "test_startup_api_mode_config_fails"
  ];

  meta = with lib; {
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
