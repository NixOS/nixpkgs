{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  json-timeseries,
  home-assistant,
  openplantbook-sdk,
  pytest-freezer,
  pytest-homeassistant,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "olen";
  domain = "openplantbook";
  version = "1.8.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-openplantbook";
    tag = "v${version}";
    hash = "sha256-oEnPIpekFs8b9iOaKIghYN8LI90hcb2kZE0D0C2pL0k=";
  };

  ignoreVersionRequirement = [
    "json-timeseries"
    "openplantbook-sdk"
  ];

  dependencies = [
    json-timeseries
    openplantbook-sdk
  ];

  nativeCheckInputs = [
    home-assistant
    pytest-freezer
    pytest-homeassistant
    pytestCheckHook
  ];

  meta = {
    description = "Integration to search and fetch data from Openplantbook.io";
    homepage = "https://github.com/Olen/home-assistant-openplantbook";
    changelog = "https://github.com/Olen/home-assistant-openplantbook/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.gpl3Only;
  };
}
