{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  requests,
}:

buildHomeAssistantComponent rec {
  owner = "hbrennhaeuser";
  domain = "ntfy";
  version = "1.2.0-pre.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant_integration_ntfy";
    rev = "v${version}";
    hash = "sha256-ydWZ4ApYQ9kyMA5A2OGXG323/7H3fa2XPiOAFBZNM30=";
  };

  dependencies = [
    requests
  ];

  meta = with lib; {
    description = "Send notifications with ntfy.sh and selfhosted ntfy-servers";
    homepage = "https://github.com/hbrennhaeuser/homeassistant_integration_ntfy";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl3;
  };
}
