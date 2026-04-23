{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  prettytable,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "dummylabs";
  domain = "watchman";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "dummylabs";
    repo = "thewatchman";
    tag = "v${version}";
    hash = "sha256-5BXIKh8uPKuxsLbxu0fUbuCR2LYOXk1HpOvrqehg0u0=";
  };

  postPatch = ''
    substituteInPlace custom_components/watchman/manifest.json \
      --replace-fail "prettytable==3.12.0" "prettytable"
  '';

  dontBuild = true;

  dependencies = [
    prettytable
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # the test relies on NOT changing the hass config_dir and tries to write into the nix store
    "test_status_sensor_safe_mode"
  ];

  meta = {
    description = "Keep track of missing entities and services in your config files";
    homepage = "https://github.com/dummylabs/thewatchman";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
