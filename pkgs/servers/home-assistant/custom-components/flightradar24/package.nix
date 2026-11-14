{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  flightradarapi,
  home-assistant,
  pycountry,
  pytest-homeassistant,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "AlexandrErohin";
  domain = "flightradar24";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "AlexandrErohin";
    repo = "home-assistant-flightradar24";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5FJngWHghZW8xvL6ZkkEJDqHVLHGgHUG/gappayuEsE=";
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
    home-assistant
    pytest-homeassistant
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
