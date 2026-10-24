{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  freezegun,
  homeassistant,
  lib,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
  syrupy,
}:

buildHomeAssistantComponent rec {
  owner = "a529987659852";
  domain = "openwb2mqtt";
  version = "0.3.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "openwb2mqtt";
    tag = "v${version}";
    hash = "sha256-C2q0Rql1gHfbMrTcK5lTABPjEIWz8P8Micoa/XmqBBE=";
  };

  nativeCheckInputs = [
    freezegun
    homeassistant
    pytest-homeassistant-custom-component
    pytestCheckHook
    syrupy
  ];

  preCheck = ''
    export PYTHONPATH="${homeassistant.src}:$PYTHONPATH"
  '';

  meta = {
    changelog = "https://github.com/a529987659852/openwb2mqtt/releases/tag/${src.tag}";
    description = "Home Assistant Integration for openWB (Version 2)";
    homepage = "https://github.com/a529987659852/openwb2mqtt";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
