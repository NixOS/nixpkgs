{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pytz,
}:

buildHomeAssistantComponent rec {
  owner = "presto8";
  domain = "frigate";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    rev = "v${version}";
    hash = "sha256-6W9U0Q0wW36RsErvtFQo1sc1AF7js6MMHxgMQcDFexw=";
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
