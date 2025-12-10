{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  websockets,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
  version = "1.4.5";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-WkXg+oIxkRIbU8L9kFJOQ798/2vR9yB0y/nuY1RWKJE=";
  };

  dependencies = [
    websockets
  ];

  meta = {
    changelog = "https://github.com/iprak/sensi/releases/tag/v${version}";
    description = "HomeAssistant integration for Sensi thermostat";
    homepage = "https://github.com/iprak/sensi";
    maintainers = with lib.maintainers; [ ivan ];
    license = lib.licenses.mit;
  };
}
