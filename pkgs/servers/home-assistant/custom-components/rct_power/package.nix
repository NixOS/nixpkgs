{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  rctclient,
}:

buildHomeAssistantComponent rec {
  owner = "weltenwort";
  domain = "rct_power";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "weltenwort";
    repo = "home-assistant-rct-power-integration";
    tag = "v${version}";
    hash = "sha256-wM66MyRhBsMfUr+KlqV4jSuXcnKfW0fkbDAyuU2crsc=";
  };

  dependencies = [
    rctclient
  ];

  ignoreVersionRequirement = [
    # rctclient 0.0.4 was never published on PyPI
    "rctclient"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    changelog = "https://github.com/weltenwort/home-assistant-rct-power-integration/releases/tag/${src.tag}";
    description = "Custom integration for RCT Power Inverters";
    homepage = "https://github.com/weltenwort/home-assistant-rct-power-integration";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
  };
}
