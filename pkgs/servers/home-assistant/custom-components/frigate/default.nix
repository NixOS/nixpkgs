{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, pytz
}:

buildHomeAssistantComponent rec {
  owner = "presto8";
  domain = "frigate";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    rev = "v${version}";
    hash = "sha256-OWpOYNVzowdn0iZfJwhdMrAYeqDpNJvSwHpsJX9fDk4=";
  };

  propagatedBuildInputs = [
    pytz
  ];

  dontBuild = true;

  meta = with lib; {
    description = "Provides Home Assistant integration to interface with a separately running Frigate service";
    homepage = "https://github.com/blakeblackshear/frigate-hass-integration";
    changelog = "https://github.com/blakeblackshear/frigate-hass-integration/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
