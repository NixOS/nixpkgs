{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  websockets,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
  version = "1.4.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-UigqkHdjyxB87t9e/bQzZ0vNfxgNDh4pX6rSUKYP7HQ=";
  };

  dependencies = [
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
