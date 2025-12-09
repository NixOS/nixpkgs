{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  # dependencies
  tinytuya,
  tuya-device-sharing-sdk,
}:

buildHomeAssistantComponent rec {
  owner = "make-all";
  domain = "tuya_local";
  version = "2025.11.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "tuya-local";
    tag = version;
    hash = "sha256-DuOzr5i5E8rP7z1TB8bPNEUSe8bz853jwW3hRREpNAY=";
  };

  dependencies = [
    tinytuya
    tuya-device-sharing-sdk
  ];

  meta = with lib; {
    description = "Local support for Tuya devices in Home Assistant";
    homepage = "https://github.com/make-all/tuya-local";
    changelog = "https://github.com/make-all/tuya-local/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pathob ];
  };
}
