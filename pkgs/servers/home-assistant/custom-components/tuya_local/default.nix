{ lib
, buildHomeAssistantComponent
, fetchFromGitHub

# dependencies
, tinytuya
, tuya-device-sharing-sdk
}:

buildHomeAssistantComponent rec {
  owner = "make-all";
  domain = "tuya_local";
  version = "2024.6.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "tuya-local";
    rev = "refs/tags/${version}";
    hash = "sha256-OLR/KFoXKqL7r7S97VpyoVHdbLfOyWU50aK6c0QhqyE=";
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
