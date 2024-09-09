{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pytz,
}:

buildHomeAssistantComponent rec {
  owner = "blakeblackshear";
  domain = "frigate";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    rev = "v${version}";
    hash = "sha256-0eTEgRDgm4+Om2uqrt24Gj7dSdA6OJs/0oi5J5SHOyI=";
  };

  dependencies = [ pytz ];

  dontBuild = true;

  meta = with lib; {
    description = "Provides Home Assistant integration to interface with a separately running Frigate service";
    homepage = "https://github.com/blakeblackshear/frigate-hass-integration";
    changelog = "https://github.com/blakeblackshear/frigate-hass-integration/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
