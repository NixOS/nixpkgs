{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, moonraker-api
}:

buildHomeAssistantComponent rec {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    rev = "refs/tags/${version}";
    hash = "sha256-e1Bdhv6YSz9yhIx5SDKfRxq0f6Fr0oc0vzpOqPPMxmc=";
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
