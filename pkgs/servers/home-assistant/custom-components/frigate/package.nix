{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pytz,
}:

buildHomeAssistantComponent rec {
  owner = "blakeblackshear";
  domain = "frigate";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    rev = "v${version}";
    hash = "sha256-V2Y+xUAA/Lu7u82WUlUI5CFi9SGWe6ocVQtlXeVg2ZA=";
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
