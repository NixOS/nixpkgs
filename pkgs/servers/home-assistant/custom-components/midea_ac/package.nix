{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  msmart-ng,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "mill1000";
  domain = "midea_ac";
  version = "2026.4.0";

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    tag = version;
    hash = "sha256-XYajDvp7K1pBlVhT553Rqa8Hi/mA8AWwchTUN4PZ+iw=";
  };

  dependencies = [ msmart-ng ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # tests try to open sockets
    "test_manual_flow_ac_device"
    "test_manual_flow_cc_device"
    # lingering datacoordinator timer on test teardown
    "test_refresh_apply_race_condition"
    "test_refresh_apply_race_condition_with_proxy"
    "test_group5_entity_request_enable"
    "test_energy_sensor_request_enable"
  ];

  meta = {
    changelog = "https://github.com/mill1000/midea-ac-py/releases/tag/${src.tag}";
    description = "Home Assistant custom integration to control Midea (and associated brands) air conditioners via LAN";
    homepage = "https://github.com/mill1000/midea-ac-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      emilylange
    ];
  };
}
