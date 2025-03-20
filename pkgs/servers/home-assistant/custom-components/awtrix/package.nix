{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  requests,
}:

buildHomeAssistantComponent rec {
  owner = "10der";
  domain = "awtrix";
  version = "0.3.21";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-custom_components-awtrix";
    # https://github.com/10der/homeassistant-custom_components-awtrix/issues/9
    rev = "8180cef7b1837e85115ef7ece553e39b0f94ff4d";
    hash = "sha256-D/RXi7nX+xqFs5Dvu1pwomQWCJ8PJhc1H3wsAgBhRMQ=";
  };

  dependencies = [
    requests
  ];

  meta = with lib; {
    description = "Home-assistant integration for awtrix";
    homepage = "https://github.com/10der/homeassistant-custom_components-awtrix";
    maintainers = with maintainers; [ pinpox ];
    license = licenses.mit;
  };
}
