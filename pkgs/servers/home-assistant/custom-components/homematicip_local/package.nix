{
  lib,
  async-upnp-client,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiohomematic,
  aiohomematic-config,
  aiohomematic-test-support,
  home-assistant,
  openccu-data,
  openccu-loom-client,
  pytest-homeassistant-custom-component,
  pytest-xdist,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "SukramJ";
  domain = "homematicip_local";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "custom_homematic";
    tag = version;
    hash = "sha256-zBtTqNxmOD844rBxPyHGCkE3GLYUH8mI5qBtPdxz24o=";
  };

  postPatch = ''
    min_ha_version="$(sed -nr 's/^HMIP_LOCAL_MIN_HA_VERSION.*= "([0-9.]+)"$/\1/p' custom_components/homematicip_local/const.py)"
    test \
      "$(printf '%s\n' "$min_ha_version" "${home-assistant.version}" | sort -V | head -n1)" = "$min_ha_version" \
      || (echo "error: only Home Assistant >= $min_ha_version is supported" && exit 1)
  '';

  dependencies = [
    aiohomematic
    aiohomematic-config
    openccu-data
    openccu-loom-client
  ];

  nativeCheckInputs = [
    aiohomematic-test-support
    async-upnp-client
    pytest-homeassistant-custom-component
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # zeroconf fails with: No such device
    "tests/test_config_flow.py::TestReauthFlow::test_reauth_flow_success"
  ];

  meta = {
    changelog = "https://github.com/SukramJ/custom_homematic/blob/${src.tag}/changelog.md";
    description = "Custom Home Assistant Component for HomeMatic";
    homepage = "https://github.com/SukramJ/custom_homematic";
    maintainers = with lib.maintainers; [ dotlambda ];
    license = lib.licenses.mit;
  };
}
