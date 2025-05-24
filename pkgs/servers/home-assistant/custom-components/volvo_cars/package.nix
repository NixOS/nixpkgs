{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "thomasddn";
  domain = "volvo_cars";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "ha-volvo-cars";
    tag = "v${version}";
    hash = "sha256-f7+RBAOkNUVJ4P/B/cMK7eGFrTnn8TGsC26vfSHc8Z4=";
  };

  meta = with lib; {
    changelog = "https://github.com/thomasddn/ha-volvo-cars/releases/tag/${src.tag}";
    homepage = "https://github.com/thomasddn/ha-volvo-cars";
    description = "Volvo Cars Home Assistant integration";
    maintainers = with maintainers; [ seberm ];
    license = licenses.gpl3Only;
  };
}
