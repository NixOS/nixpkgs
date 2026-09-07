{
  lib,
  attrs,
  bellows,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  frozendict,
  looptime,
  pyprojectVersionPatchHook,
  pytest-asyncio_0,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zigpy,
  zigpy-deconz,
  zigpy-xbee,
  zigpy-zigate,
  zigpy-ziggurat,
  zigpy-znp,
  zha,
  zha-quirks,
}:

buildPythonPackage (finalAttrs: {
  pname = "zha";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha";
    tag = finalAttrs.version;
    hash = "sha256-Gmfi7ogDylvf3FKVQGkVjTzuT8zAfAbqIDfbWQOCF88=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<3"' ""

    # do not install development tools
    rm -r tools
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    bellows
    frozendict
    zigpy
    zigpy-deconz
    zigpy-xbee
    zigpy-zigate
    zigpy-ziggurat
    zigpy-znp
  ];

  nativeCheckInputs = [
    freezegun
    looptime
    pytest-asyncio_0
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    zha-quirks
  ];

  pythonImportsCheck = [ "zha" ];

  doCheck = false; # infinite recursion with zhaquirks

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
    "test_gateway_startup_failure" # Failed first attempt, passed second, flaky
  ];

  passthru.tests = {
    pytest = zha.overridePythonAttrs { doCheck = true; };
  };

  meta = {
    description = "Zigbee Home Automation";
    homepage = "https://github.com/zigpy/zha";
    changelog = "https://github.com/zigpy/zha/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
