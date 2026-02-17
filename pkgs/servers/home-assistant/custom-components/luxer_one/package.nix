{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "tjhorner";
  domain = "luxer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "home-assistant-luxer-one";
    tag = "v${version}";
    hash = "sha256-D92PhI23iGbSqvc1Myi9+KHYXpeArivXwFS5bGLn8Tk=";
  };

  meta = {
    changelog = "https://github.com/tjhorner/home-assistant-luxer-one/releases/tag/${src.tag}";
    description = "Home Assistant integration for Luxer One";
    homepage = "https://github.com/tjhorner/home-assistant-luxer-one";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
