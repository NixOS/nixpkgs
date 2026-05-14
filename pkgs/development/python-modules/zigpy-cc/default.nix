{
  lib,
  asynctest,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial-asyncio,
  pytest-asyncio,
  pytestCheckHook,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-cc";
  version = "0.5.2";
  format = "setuptools";

  # https://github.com/Martiusweb/asynctest/issues/152
  # broken by upstream python bug with asynctest and
  # is used exclusively by home-assistant with python 3.8

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-cc";
    rev = version;
    sha256 = "U3S8tQ3zPlexZDt5GvCd+rOv7CBVeXJJM1NGe7nRl2o=";
  };

  propagatedBuildInputs = [
    pyserial-asyncio
    zigpy
  ];

  doCheck = false; # asynctest unsupported on 3.11+

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    "test_incoming_msg"
    "test_incoming_msg2"
    "test_deser"
    # Fails in sandbox
    "tests/test_application.py "
  ];

  pythonImportsCheck = [ "zigpy_cc" ];

  meta = {
    description = "Library which communicates with Texas Instruments CC2531 radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-cc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
}
