{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "jwillemsen";
  domain = "daikin_onecta";
<<<<<<< HEAD
  version = "4.4.4";
=======
  version = "4.2.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jwillemsen";
    repo = "daikin_onecta";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8a5P+eoa3iEER4b2SlsYi+feyPnc4n4RYzl6Lg+nqmQ=";
=======
    hash = "sha256-bV+4nTRhtqSVBdaG3rCtIdTYhM4pqcQCtUQwsUhgcq0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    changelog = "https://github.com/jwillemsen/daikin_onecta/releases/tag/v${version}";
    description = "Home Assistant Integration for devices supported by the Daikin Onecta App";
    homepage = "https://github.com/jwillemsen/daikin_onecta";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl3Only;
  };
}
