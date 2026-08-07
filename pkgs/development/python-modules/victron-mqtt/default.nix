{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  paho-mqtt,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  victron-vrm,
}:

buildPythonPackage (finalAttrs: {
  pname = "victron-mqtt";
  version = "2026.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomer-w";
    repo = "victron_mqtt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5bY5IG+WgCwgAv4i/RidiRmEzO0iuhTBKRl63nMdnAo=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    paho-mqtt
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # requires local mqtt broker
    "test_connect"
    "test_create_full_raw_snapshot"
    "test_devices_and_metrics"
    "test_two_hubs_connect"
    # network access
    "test_connect_auth_failure"
  ];

  pythonImportsCheck = [
    "victron_mqtt"
  ];

  meta = {
    changelog = "https://github.com/tomer-w/victron_mqtt/releases/tag/${finalAttrs.src.tag}";
    description = "Victron Venus MQTT client library documentation";
    homepage = "https://github.com/tomer-w/victron_mqtt";
    license = lib.licenses.mit;
    inherit (victron-vrm.meta) maintainers;
  };
})
