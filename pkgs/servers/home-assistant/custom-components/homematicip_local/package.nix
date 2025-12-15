{
  lib,
  async-upnp-client,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiohomematic,
  aiohomematic-test-support,
  home-assistant,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "SukramJ";
  domain = "homematicip_local";
  version = "1.90.2";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "custom_homematic";
    tag = version;
    hash = "sha256-ARBCwwvGFODMBNf0Ds4DL65V8LKm9nfiKaPUn0c6kYE=";
  };

  postPatch = ''
    min_ha_version="$(sed -nr 's/^HMIP_LOCAL_MIN_HA_VERSION.*= "([0-9.]+)"$/\1/p' custom_components/homematicip_local/const.py)"
    test \
      "$(printf '%s\n' "$min_ha_version" "${home-assistant.version}" | sort -V | head -n1)" = "$min_ha_version" \
      || (echo "error: only Home Assistant >= $min_ha_version is supported" && exit 1)
  '';

  dependencies = [
    aiohomematic
  ];

  nativeCheckInputs = [
    aiohomematic-test-support
    async-upnp-client
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # custom_components.homematicip_local.support.InvalidConfig: C
    "test_async_validate_config_and_get_system_information"
  ];

  meta = {
    changelog = "https://github.com/SukramJ/custom_homematic/blob/${src.tag}/changelog.md";
    description = "Custom Home Assistant Component for HomeMatic";
    homepage = "https://github.com/SukramJ/custom_homematic";
    maintainers = with lib.maintainers; [ dotlambda ];
    license = lib.licenses.mit;
  };
}
