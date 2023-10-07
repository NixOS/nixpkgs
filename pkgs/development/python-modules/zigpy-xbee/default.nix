{ lib
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
  version = "0.18.3";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-xbee";
    rev = "refs/tags/${version}";
    hash = "sha256-+qtbOC3rsse57kqd4RLl9EKXzru0vdgIIPSl1OQ652U=";
  };

  buildInputs = [
    pyserial
    pyserial-asyncio
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # fixed in https://github.com/zigpy/zigpy-xbee/commit/f85233fc28ae01c08267965e99a29e43b00e1561
    "test_shutdown"
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
