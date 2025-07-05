{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "thomasddn";
  domain = "volvo_cars";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "ha-volvo-cars";
    tag = "v${version}";
    hash = "sha256-oAGUa8KxLbzZs7xw/P9kwwG/ija03HXJ4jACluUd048=";
  };

  meta = with lib; {
    changelog = "https://github.com/thomasddn/ha-volvo-cars/releases/tag/${src.tag}";
    homepage = "https://github.com/thomasddn/ha-volvo-cars";
    description = "Volvo Cars Home Assistant integration";
    maintainers = with maintainers; [ seberm ];
    license = licenses.gpl3Only;
  };
}
