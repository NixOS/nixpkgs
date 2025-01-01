{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "xZetsubou";
  domain = "localtuya";
  version = "2024.12.1";

  src = fetchFromGitHub {
    owner = "xZetsubou";
    repo = "hass-localtuya";
    rev = version;
    hash = "sha256-S55TQuU3faEjLYsBnc8elk82csicjIH1xX2bsXjX21Q=";
  };

  meta = with lib; {
    changelog = "https://github.com/xZetsubou/hass-localtuya/releases/tag/${version}";
    description = "Home Assistant custom Integration for local handling of Tuya-based devices, fork from local-tuya";
    homepage = "https://github.com/xZetsubou/hass-localtuya";
    maintainers = with maintainers; [ eliandoran ];
    license = licenses.gpl3Only;
  };
}
