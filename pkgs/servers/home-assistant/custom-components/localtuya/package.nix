{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "xZetsubou";
  domain = "localtuya";
  version = "2025.6.0";

  src = fetchFromGitHub {
    owner = "xZetsubou";
    repo = "hass-localtuya";
    rev = version;
    hash = "sha256-P5qUvlpKwcbIERzDyImc79Gzmr1IHweH8SLM6QFhb5I=";
  };

  meta = with lib; {
    changelog = "https://github.com/xZetsubou/hass-localtuya/releases/tag/${version}";
    description = "Home Assistant custom Integration for local handling of Tuya-based devices, fork from local-tuya";
    homepage = "https://github.com/xZetsubou/hass-localtuya";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl3Only;
  };
}
