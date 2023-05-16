{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchFromGitHub
=======
, asynctest
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-xbee";
<<<<<<< HEAD
  version = "0.18.2";
=======
  version = "0.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-xbee";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-aglKQWIMh0IyrcGt+PZVtzcgs88YbtZB7Tfg7hlB+18=";
=======
    hash = "sha256-zSaT9WdA4tR8tJAShSzqL+f/nTLQJbeIZnbSBe1EOks=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    pyserial
    pyserial-asyncio
    zigpy
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
=======
    asynctest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/zigpy/zigpy-xbee/issues/126
    "test_form_network"
  ];

  meta = with lib; {
    changelog = "https://github.com/zigpy/zigpy-xbee/releases/tag/${version}";
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
