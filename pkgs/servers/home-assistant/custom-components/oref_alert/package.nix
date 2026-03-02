{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiofiles,
  shapely,
  paho-mqtt,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-freezer,
}:

buildHomeAssistantComponent rec {
  owner = "amitfin";
  domain = "oref_alert";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "amitfin";
    repo = "oref_alert";
    tag = "v${version}";
    hash = "sha256-nWp8cG0lFYUEO11lcZGkqx5QvOSfSVnqIqpHA8YAN30=";
  };

  dependencies = [
    aiofiles
    shapely
    paho-mqtt
  ];

  ignoreVersionRequirement = [ "shapely" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    pytest-freezer
  ];

  meta = {
    changelog = "https://github.com/amitfin/oref_alert/releases/tag/v${version}";
    description = "Israeli Oref Alerts";
    homepage = "https://github.com/amitfin/oref_alert";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
