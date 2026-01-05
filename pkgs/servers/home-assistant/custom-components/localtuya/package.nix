{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "xZetsubou";
  domain = "localtuya";
  version = "2025.11.0";

  src = fetchFromGitHub {
    owner = "xZetsubou";
    repo = "hass-localtuya";
    tag = version;
    hash = "sha256-TISiZchkLZ3AaNh622nolIyBjDgdJBQrc30oBHN/INE=";
  };

  meta = with lib; {
    changelog = "https://github.com/xZetsubou/hass-localtuya/releases/tag/${version}";
    description = "Home Assistant custom Integration for local handling of Tuya-based devices, fork from local-tuya";
    homepage = "https://github.com/xZetsubou/hass-localtuya";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl3Only;
  };
}
