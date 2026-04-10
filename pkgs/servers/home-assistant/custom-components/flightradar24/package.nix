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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "AlexandrErohin";
    repo = "home-assistant-flightradar24";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PosY4XkONbQk+9w20TbbNT2q+JuoG0vacbsZ8HfRdg4=";
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
    changelog = "https://github.com/AlexandrErohin/home-assistant-flightradar24/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
