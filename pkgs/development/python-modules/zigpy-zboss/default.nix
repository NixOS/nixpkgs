{
  async-timeout,
  buildPythonPackage,
  coloredlogs,
  fetchFromGitHub,
  jsonschema,
  lib,
  pytest-asyncio,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-T2R291GeFIsnDRI1tAydTlLamA3LF5tKxKFhPtcEUus=";
  };

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    coloredlogs
    jsonschema
    voluptuous
    zigpy
  ];

  pythonImportsCheck = [ "zigpy_zboss" ];

  nativeCheckInputs = [
    pytest-asyncio
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
