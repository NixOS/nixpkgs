{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyhaversion,
  nix-update-script,
  # Test dependencies
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  aiohttp-cors,
  paho-mqtt,
}:
let
  version = "2.3.2";
in
buildHomeAssistantComponent {
  owner = "IATkachenko";
  domain = "sleep_as_android";
  inherit version;

  src = fetchFromGitHub {
    owner = "IATkachenko";
    repo = "HA-SleepAsAndroid";
    tag = "v${version}";
    hash = "sha256-aJKjHZcRdmiXJdtWRY4fv5oxCHTDIVpvZEwhIE9ISv8=";
  };

  dependencies = [
    pyhaversion
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    aiohttp-cors
    paho-mqtt
  ];

  pytestFlagsArray = [
    # Fixes `AttributeError: 'async_generator' object has no attribute 'data'`
    #  See https://github.com/MatthewFlamm/pytest-homeassistant-custom-component/issues/158
    "--asyncio-mode=auto"
  ];

  disabledTests = [
    # Broken on upstream, see https://github.com/IATkachenko/HA-SleepAsAndroid/issues/85
    #  AttributeError: module 'homeassistant.data_entry_flow' has no attribute 'RESULT_TYPE_FORM'
    "test_successful_config_flow"
    "test_options_flow"

    # Likely fails due to --asyncio-mode=auto
    #  TypeError: object MagicMock can't be used in 'await' expression
    "test_async_setup_entry"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sleep As Android integration for Home Assistant";
    homepage = "https://github.com/IATkachenko/HA-SleepAsAndroid";
    changelog = "https://github.com/IATkachenko/HA-SleepAsAndroid/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ blenderfreaky ];
  };
}
