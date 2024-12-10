{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  moonraker-api,
}:

buildHomeAssistantComponent rec {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    rev = "refs/tags/${version}";
    hash = "sha256-oFHV9+5byWCOUxUhOvGHNilCZaoOp2xxb33nF8+CYjE=";
  };

  propagatedBuildInputs = [
    moonraker-api
  ];

  #skip phases with nothing to do
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${version}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
  };
}
