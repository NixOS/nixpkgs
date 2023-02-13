{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-xbee";
  version = "0.16.2";
  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-xbee";
    rev = "refs/tags/${version}";
    sha256 = "sha256-EzdKY/VisMUc/5yHN+7JUz1fDM4mCpk5TyApC24z4CU=";
  };

  buildInputs = [
    pyserial
    pyserial-asyncio
    zigpy
  ];

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/zigpy/zigpy-xbee/issues/126
    "test_form_network"
  ];

  meta = with lib; {
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
