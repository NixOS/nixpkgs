{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.134";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    tag = version;
    hash = "sha256-9h9Fsn15/1fZIiZEyGPIzuyxmGs7L4PyEwH/K2cRSgU=";
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
  ];

  disabledTests = [
    # RuntimeError: no running event loop
    "test_mfg_cluster_events"
    "test_co2_sensor"
    "test_smart_air_sensor"
  ];

  pythonImportsCheck = [ "zhaquirks" ];

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    changelog = "https://github.com/zigpy/zha-device-handlers/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
