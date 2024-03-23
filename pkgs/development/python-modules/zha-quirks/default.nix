{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, zigpy
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.112";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = "refs/tags/${version}";
    hash = "sha256-wI7mpX6oFV/RrxH/UP1X9Odago0CxJ5dhjKAsDS+Sq4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "zhaquirks"
  ];

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    changelog = "https://github.com/zigpy/zha-device-handlers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
