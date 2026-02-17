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
  version = "2026.1.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "tuya-local";
    tag = version;
    hash = "sha256-PZ/pcjI67UDPPqMUrrgXXOHYo4VmduaRN3tvvEbZcPc=";
  };

  dependencies = [
    tinytuya
    tuya-device-sharing-sdk
  ];

  meta = {
    description = "Local support for Tuya devices in Home Assistant";
    homepage = "https://github.com/make-all/tuya-local";
    changelog = "https://github.com/make-all/tuya-local/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pathob ];
  };
}
