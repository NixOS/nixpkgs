{
  lib,
  awesomeversion,
  bellows,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pyserial,
  pyserial-asyncio,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  python-slugify,
  pythonOlder,
  setuptools,
  universal-silabs-flasher,
  wheel,
  zha-quirks,
  zigpy,
  zigpy-deconz,
  zigpy-xbee,
  zigpy-zigate,
  zigpy-znp,
}:

buildPythonPackage rec {
  pname = "zha";
  version = "0.0.33";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha";
    rev = "refs/tags/${version}";
    hash = "sha256-qcXKHIiEm1wqcQKRH+TqgQMPZbLqNnBiR6dbmLwxW1Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<3"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    awesomeversion
    bellows
    pyserial
    pyserial-asyncio
    pyserial-asyncio-fast
    python-slugify
    universal-silabs-flasher
    zha-quirks
    zigpy
    zigpy-deconz
    zigpy-xbee
    zigpy-zigate
    zigpy-znp
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zha" ];

  disabledTests = [
    # Tests are long-running and often keep hanging
    "test_check_available_no_basic_cluster_handler"
    "test_check_available_success"
    "test_check_available_unsuccessful"
    "test_device_counter_sensors"
    "test_device_tracker"
    "test_device_unavailable_or_disabled_skips_entity_polling"
    "test_elec_measurement_sensor_polling"
    "test_electrical_measurement_init"
    "test_group_member_assume_state"
    "test_light_refresh"
    "test_light"
    "test_light"
    "test_light"
    "test_pollers_skip"
    "test_sinope_time"
    "test_siren_timed_off"
    "test_zha_group_light_entity"
    # flaky, either due to race conditions or timeouts
    "test_zha_group_switch_entity"
    "test_zha_group_fan_entity"
    "test_startup_concurrency_limit"
    "test_fan_ikea"
    "test_background"
  ];

  disabledTestPaths = [ "tests/test_cluster_handlers.py" ];

  pytestFlagsArray = [
    "-v"
    "--timeout=5"
  ];

  meta = with lib; {
    description = "Zigbee Home Automation";
    homepage = "https://github.com/zigpy/zha";
    changelog = "https://github.com/zigpy/zha/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
