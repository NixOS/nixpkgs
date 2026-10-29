{
  lib,
  async-timeout,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchpatch,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "olen";
  domain = "plant";
  version = "2026.9.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "homeassistant-plant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8V+90Onh3MLN8G4CjenzZWznwnGiWfhz17KZhGd1qYk=";
  };

  patches = [
    # Remove assertion for deprecated field
    (fetchpatch {
      url = "https://github.com/Olen/homeassistant-plant/commit/1da473a4c9cf02267e41756028f67f2847e11b97.patch";
      hash = "sha256-lfo29gqs/6RgEBD2xwjsthGruFS/S+QPcnQ+I/bhd1k=";
    })
  ];

  dependencies = [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Alternative Plant component of home assistant";
    homepage = "https://github.com/Olen/homeassistant-plant";
    changelog = "https://github.com/Olen/homeassistant-plant/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.gpl3Only;
  };
})
