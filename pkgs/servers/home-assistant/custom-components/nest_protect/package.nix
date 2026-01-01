{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent rec {
  owner = "iMicknl";
  domain = "nest_protect";
  version = "0.4.2b0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-nest-protect";
    tag = "v${version}";
    hash = "sha256-CQVAvx7iRCRHw8YXDmsWaF6fhddx3OfSLjq218+ob6I=";
  };

  # AttributeError: 'async_generator' object has no attribute 'data'
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/iMicknl/ha-nest-protect/releases/tag/v${version}";
    description = "Nest Protect integration for Home Assistant";
    homepage = "https://github.com/iMicknl/ha-nest-protect";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/iMicknl/ha-nest-protect/releases/tag/v${version}";
    description = "Nest Protect integration for Home Assistant";
    homepage = "https://github.com/iMicknl/ha-nest-protect";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
