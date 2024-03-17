{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  websockets,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
  version = "1.3.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/v${version}";
    hash = "sha256-RF182b6OBpoXfDsalwZntuaN8VxkQK2jy9qa0zNFQdI=";
  };

  propagatedBuildInputs = [
    websockets
  ];

  meta = with lib; {
    changelog = "https://github.com/iprak/sensi/releases/tag/v${version}";
    description = "HomeAssistant integration for Sensi thermostat";
    homepage = "https://github.com/iprak/sensi";
    maintainers = with maintainers; [ ivan ];
    license = licenses.mit;
  };
}
