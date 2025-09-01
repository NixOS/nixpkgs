{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ruff,
}:

buildHomeAssistantComponent rec {
  owner = "tjhorner";
  domain = "luxer";
  version = "0-unstable-2023-03-27";

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "home-assistant-luxer-one";
    rev = "f6a810034ab76e6a8635de755c4a1750e86b1674";
    hash = "sha256-WmsL0NLe2ICqNGbEQ4vg1EzcZgIGi++G9aDyKjnmJMs=";
  };

  meta = {
    description = "Home Assistant integration for Luxer One";
    homepage = "https://github.com/tjhorner/home-assistant-luxer-one";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
