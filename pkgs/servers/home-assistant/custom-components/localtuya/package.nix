{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "xZetsubou";
  domain = "localtuya";
  version = "2026.7.0";

  src = fetchFromGitHub {
    owner = "xZetsubou";
    repo = "hass-localtuya";
    tag = version;
    hash = "sha256-gJk5AWNIk0d8Xdamk3VM7huxszN+QsQjo75bs2jZeM8=";
  };

  meta = {
    changelog = "https://github.com/xZetsubou/hass-localtuya/releases/tag/${version}";
    description = "Home Assistant custom Integration for local handling of Tuya-based devices, fork from local-tuya";
    homepage = "https://github.com/xZetsubou/hass-localtuya";
    maintainers = with lib.maintainers; [ rhoriguchi ];
    license = lib.licenses.gpl3Only;
  };
}
