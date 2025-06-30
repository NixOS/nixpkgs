{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  websockets,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
  version = "1.3.15";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-t6SOjjoMQ2V+KcqFx03PJPrbviDmidi+XbQGlQ5ghuc=";
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
