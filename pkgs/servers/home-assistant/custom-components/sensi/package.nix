{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  python-socketio,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
  version = "2.2.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-lxZWbXCcJXE/jMxrFNU3qcPnRYxlt1dLPwW1WBToRYc=";
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
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
