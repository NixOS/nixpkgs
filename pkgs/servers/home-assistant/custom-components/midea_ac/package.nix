{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  msmart-ng,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "mill1000";
  domain = "midea_ac";
  version = "2026.11.0";

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    tag = version;
    hash = "sha256-R+BFZSAuY6BWvIqvaPKqC4qWHwlkGXHbzbVoWO4pPrE=";
  };

  dependencies = [ msmart-ng ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/mill1000/midea-ac-py/releases/tag/${src.tag}";
    description = "Home Assistant custom integration to control Midea (and associated brands) air conditioners via LAN";
    homepage = "https://github.com/mill1000/midea-ac-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
    ];
  };
}
