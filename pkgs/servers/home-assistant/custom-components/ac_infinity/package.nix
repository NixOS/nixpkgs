{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "dalinicus";
  domain = "ac_infinity";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dalinicus";
    repo = "homeassistant-acinfinity";
    rev = "${version}";
    hash = "sha256-Su2KE8pay8xguAb9VaorLoe4badFGM1bwgsTCmX6Nbg=";
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Home Assistant integration for AC Infinity devices";
    changelog = "https://github.com/dalinicus/homeassistant-acinfinity/releases/tag/v${version}";
    homepage = "https://github.com/dalinicus/homeassistant-acinfinity";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
