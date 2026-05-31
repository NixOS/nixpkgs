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
  pytest-cov-stub,
  home-assistant-frontend,
}:

buildHomeAssistantComponent rec {
  owner = "amitfin";
  domain = "oref_alert";
  version = "6.20.0";

  src = fetchFromGitHub {
    owner = "amitfin";
    repo = "oref_alert";
    tag = "v${version}";
    hash = "sha256-bQGviqvDFzkp64H4lxAvxP2UrAgFj0iFJ+QF+1GTGA4=";
  };

  # Do not publish cards, currently broken, attempting to write to nix store.
  postPatch = ''
    substituteInPlace custom_components/oref_alert/__init__.py \
      --replace-fail 'version = await publish_cards(hass)' 'version = "1.0.0"'
  '';

  dependencies = [
    aiofiles
    shapely
    paho-mqtt
  ];

  ignoreVersionRequirement = [ "shapely" ];

  # These tests are broken with cards removed.
  disabledTestPaths = [
    "tests/test_custom_cards.py"
    "tests/test_init.py"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    pytest-freezer
    pytest-cov-stub
    home-assistant-frontend
  ];

  meta = {
    changelog = "https://github.com/amitfin/oref_alert/releases/tag/v${version}";
    description = "Israeli Oref Alerts";
    homepage = "https://github.com/amitfin/oref_alert";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
