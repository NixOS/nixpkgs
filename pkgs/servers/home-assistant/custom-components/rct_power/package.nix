{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  rctclient,
}:

buildHomeAssistantComponent rec {
  owner = "weltenwort";
  domain = "rct_power";
  version = "v0.14.1";

  src = fetchFromGitHub {
    owner = "weltenwort";
    repo = "home-assistant-rct-power-integration";
    tag = version;
    hash = "sha256-wM66MyRhBsMfUr+KlqV4jSuXcnKfW0fkbDAyuU2crsc=";
  };

  dependencies = [
    rctclient
  ];

  doCheck = false; # no tests

  meta = {
    changelog = "https://github.com/weltenwort/home-assistant-rct-power-integration/releases/tag/${src.tag}";
    description = "Custom integration for RCT Power Inverters";
    homepage = "https://github.com/weltenwort/home-assistant-rct-power-integration";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
}
