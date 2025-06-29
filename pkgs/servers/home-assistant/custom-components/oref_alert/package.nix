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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "amitfin";
    repo = "oref_alert";
    tag = "v${version}";
    hash = "sha256-6OCrLf9oa7ihnivosZzW5VybNQntZfjp+DEaEgiXx4w=";
  };

  postPatch = ''
    substituteInPlace custom_components/oref_alert/manifest.json \
      --replace-fail shapely==2.0.7 shapely
  '';

  dependencies = [
    aiofiles
    shapely
    paho-mqtt
  ];

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
