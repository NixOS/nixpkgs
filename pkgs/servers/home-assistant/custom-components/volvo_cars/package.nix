{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "thomasddn";
  domain = "volvo_cars";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "ha-volvo-cars";
    tag = "v${version}";
    hash = "sha256-2wRqEa7jVumbRNCGrFa0gYEzgGwUrMnW2A8JhPTTMCc=";
  };

  meta = {
    changelog = "https://github.com/thomasddn/ha-volvo-cars/releases/tag/${src.tag}";
    homepage = "https://github.com/thomasddn/ha-volvo-cars";
    description = "Volvo Cars Home Assistant integration";
    maintainers = with lib.maintainers; [
      matteopacini
      seberm
    ];
    license = lib.licenses.gpl3Only;
  };
}
