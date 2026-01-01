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
<<<<<<< HEAD
  version = "2025.12.2";
=======
  version = "2025.11.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    inherit owner;
    repo = "tuya-local";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-kqSrNbTZsP8lYJi+Uly6TGs2ZFFQ9bMT8AvGhTb/QWE=";
=======
    hash = "sha256-DuOzr5i5E8rP7z1TB8bPNEUSe8bz853jwW3hRREpNAY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    tinytuya
    tuya-device-sharing-sdk
  ];

<<<<<<< HEAD
  meta = {
    description = "Local support for Tuya devices in Home Assistant";
    homepage = "https://github.com/make-all/tuya-local";
    changelog = "https://github.com/make-all/tuya-local/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pathob ];
=======
  meta = with lib; {
    description = "Local support for Tuya devices in Home Assistant";
    homepage = "https://github.com/make-all/tuya-local";
    changelog = "https://github.com/make-all/tuya-local/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pathob ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
