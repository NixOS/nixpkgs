{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,

  # dependency
  moonraker-api,
}:

buildHomeAssistantComponent rec {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    tag = version;
    hash = "sha256-+Ra+mQm9I/cxPN0ybfD+Oo0I/LrhiTogD6m0pd0QAEM=";
  };

  dependencies = [
    moonraker-api
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python.pkgs;

  #skip phases with nothing to do
  dontConfigure = true;

  meta = {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${version}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
}
