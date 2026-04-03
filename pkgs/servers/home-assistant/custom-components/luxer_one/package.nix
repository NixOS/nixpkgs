{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "tjhorner";
  domain = "luxer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "home-assistant-luxer-one";
    tag = "v${version}";
    hash = "sha256-bzAdroFE25L0gy1FURYF5p8BaTjzHKtmpKWweDAQH0s=";
  };

  meta = {
    changelog = "https://github.com/tjhorner/home-assistant-luxer-one/releases/tag/${src.tag}";
    description = "Home Assistant integration for Luxer One";
    homepage = "https://github.com/tjhorner/home-assistant-luxer-one";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
