{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  rctclient,
}:

buildHomeAssistantComponent rec {
  owner = "weltenwort";
  domain = "rct_power";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "weltenwort";
    repo = "home-assistant-rct-power-integration";
    tag = "v${version}";
    hash = "sha256-AsDMHPKCpbne2ZcRelcIgxm1i/RZcFU8fLOvkwEodOE=";
  };

  dependencies = [
    rctclient
  ];

  ignoreVersionRequirement = [
    # rctclient 0.0.4 was never published on PyPI
    "rctclient"
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
