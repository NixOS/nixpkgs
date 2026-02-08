{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  python-socketio,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
  version = "2.1.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-B55gFiSdWRnFMIs8vbL/euvtRcJNb5ue21RE3W5f7Ic=";
  };

  postPatch = ''
    substituteInPlace custom_components/sensi/manifest.json \
      --replace-fail "==" ">="
  '';

  dependencies = [
    python-socketio
  ];

  meta = {
    changelog = "https://github.com/iprak/sensi/releases/tag/v${version}";
    description = "HomeAssistant integration for Sensi thermostat";
    homepage = "https://github.com/iprak/sensi";
    maintainers = with lib.maintainers; [ ivan ];
    license = lib.licenses.mit;
  };
}
