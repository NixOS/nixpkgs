{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  cachetools,
  meshcore,
  meshcore-cli,
  paho-mqtt,
  pynacl,
  pytest-asyncio,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "meshcore-dev";
  domain = "meshcore";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I4AUa66/XmXSb40suDGab6om2m/qJiUysXQdniT42bw=";
  };

  dependencies = [
    cachetools
    meshcore
    meshcore-cli
    paho-mqtt
    pynacl
  ];

  ignoreVersionRequirement = [
    "meshcore"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTestPaths = [
    # https://github.com/meshcore-dev/meshcore-ha/issues/363
    "tests_integration/test_dedup_eviction.py"
    "tests_integration/test_execute_command_authorization.py"
    "tests_integration/test_repeater_firmware_button.py"
    "tests_integration/test_multihub_messaging.py"
    "tests_integration/test_create_contact_sensor.py"
    "tests_integration/test_config_flow.py"
    "tests/test_cli_command.py::test_command_ui_records_when_flag_set"
    "tests/test_cli_command.py::test_command_ui_noop_on_empty_input"
  ];

  meta = {
    changelog = "https://github.com/meshcore-dev/meshcore-ha/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant integration for MeshCore";
    homepage = "https://github.com/meshcore-dev/meshcore-ha/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
})
