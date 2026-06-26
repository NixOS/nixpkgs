{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  time-machine,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    tag = version;
    hash = "sha256-mDcvVwqzSmszaJDahzkRNteiO4C/eU+BqTdBpWj5yGw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    time-machine
  ];

  disabledTests = [
    # AssertionError: expected call not found
    "test_tuya_mcu_set_time"
  ];

  disabledTestPaths = [
    # function signature mismatch with zigpy 1.5.1
    "tests/test_tuya.py"
    "tests/test_tuya_builder.py"
    "tests/test_tuya_dimmer.py"
    "tests/test_tuya_rcbo.py"
    "tests/test_tuya_siren.py"
    "tests/test_tuya_spells.py"
    "tests/test_tuya_trv.py"
    "tests/test_tuya_valve.py"
  ];

  pythonImportsCheck = [ "zhaquirks" ];

  meta = {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/zigpy/zha-device-handlers";
    changelog = "https://github.com/zigpy/zha-device-handlers/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
