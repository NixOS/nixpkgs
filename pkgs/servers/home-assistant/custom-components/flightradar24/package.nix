{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  flightradarapi,
  pycountry,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "AlexandrErohin";
  domain = "flightradar24";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "AlexandrErohin";
    repo = "home-assistant-flightradar24";
    tag = "v${finalAttrs.version}";
    hash = "sha256-50sla8WkM/oQ0+Y/1tBdI4+JHT2V09uFqkSj9IFV0+Q=";
  };

  ignoreVersionRequirement = [
    "FlightRadarAPI"
    "pycountry"
  ];

  dependencies = [
    flightradarapi
    pycountry
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Flightradar24 integration for Home Assistant";
    homepage = "https://github.com/AlexandrErohin/home-assistant-flightradar24";
    changelog = "https://github.com/AlexandrErohin/home-assistant-flightradar24/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
