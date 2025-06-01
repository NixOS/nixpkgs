{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  shapely,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-freezer,
}:

buildHomeAssistantComponent rec {
  owner = "amitfin";
  domain = "oref_alert";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "amitfin";
    repo = "oref_alert";
    tag = "v${version}";
    hash = "sha256-EsDGH7/newjHRYu4Lr5UkJ3qaaNupqlhe5CdffEpIVg=";
  };

  dependencies = [
    shapely
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
