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
  pytest-homeassistant-custom-component,
  pytest-xdist,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "SukramJ";
  domain = "homematicip_local";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "custom_homematic";
    tag = version;
    hash = "sha256-9dXvIxMMdHTOi9JbRsHbySqRUYq6dN+MzrOocq9cpdA=";
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
  ];

  nativeCheckInputs = [
    aiohomematic-test-support
    async-upnp-client
    pytest-homeassistant-custom-component
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tries to write to the Nix store
    "tests/test_blueprints.py"
  ];

  disabledTests = [
    # custom_components.homematicip_local.support.InvalidConfig: C
    "test_async_validate_config_and_get_system_information"
    # Failed: Lingering timer after test <TimerHandle when=3043632.864116499 Store._async_schedule_callback_delayed_write() created at /nix/store/5rh57mhaihd9wff1rqnskvs8nxh9sv3z-homeassistant-2026.6.0/lib/python3.14/site-packages/homeassistant/helpers/storage.py:516>
    "test_reauth_flow_success"
  ];

  meta = {
    changelog = "https://github.com/SukramJ/custom_homematic/blob/${src.tag}/changelog.md";
    description = "Custom Home Assistant Component for HomeMatic";
    homepage = "https://github.com/SukramJ/custom_homematic";
    maintainers = with lib.maintainers; [ dotlambda ];
    license = lib.licenses.mit;
  };
}
