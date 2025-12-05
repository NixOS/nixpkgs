{
  buildPythonPackage,
  coloredlogs,
  fetchFromGitHub,
  fetchpatch,
  jsonschema,
  lib,
  pytest-asyncio_0,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-zboss";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kardia-as";
    repo = "zigpy-zboss";
    tag = "v${version}";
    hash = "sha256-T2R291GeFIsnDRI1tAydTlLamA3LF5tKxKFhPtcEUus=";
  };

  patches = [
    # https://github.com/kardia-as/zigpy-zboss/pull/66
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio-timeout.patch";
      url = "https://github.com/kardia-as/zigpy-zboss/commit/91688873ddbcd0c2196f0da69a857b2e2bec75a6.patch";
      excludes = [ "setup.cfg" ];
      hash = "sha256-aC0+FbbtuHDW3ApJDnTG3TUeNWhzecEYVuiSOik03uU=";
    })
    (fetchpatch {
      # https://github.com/kardia-as/zigpy-zboss/pull/67
      name = "replace-pyserial-asyncio-with-pyserial-asyncio-fast.patch";
      url = "https://github.com/kardia-as/zigpy-zboss/commit/d44ceb537dc16ce020f8c60a0ff35e88672f3455.patch";
      hash = "sha256-aXWRtBLDr9NLIMNK/xtsYuy/hEB2zHU3YYcRKbguTTo=";
    })
  ];

  pythonRemoveDeps = [ "async_timeout" ];

  build-system = [ setuptools ];

  dependencies = [
    coloredlogs
    jsonschema
    voluptuous
    zigpy
  ];

  pythonImportsCheck = [ "zigpy_zboss" ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # AttributeError: 'Ledvance' object has no attribute 'get'
    "tests/application/test_connect.py"
    "tests/application/test_join.py"
    "tests/application/test_requests.py"
    "tests/application/test_startup.py"
    "tests/application/test_zdo_requests.py"
    "tests/application/test_zigpy_callbacks.py"
  ];

  meta = {
    changelog = "https://github.com/kardia-as/zigpy-zboss/releases/tag/v${version}";
    description = "Library for zigpy which communicates with Nordic nRF52 radios";
    homepage = "https://github.com/kardia-as/zigpy-zboss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
