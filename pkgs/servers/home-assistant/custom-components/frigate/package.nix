{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pytz,
  hass-web-proxy-lib,
}:

buildHomeAssistantComponent rec {
  owner = "blakeblackshear";
  domain = "frigate";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v${version}";
    hash = "sha256-rwPJdTN7UrFM7GaKfX2veYxmr2XodvaprNcjjVO/ciI=";
  };

  dependencies = [
    pytz
    hass-web-proxy-lib
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
