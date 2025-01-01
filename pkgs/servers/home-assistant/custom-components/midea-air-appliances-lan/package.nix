{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  midea-beautiful-air,
}:

buildHomeAssistantComponent rec {
  owner = "nbogojevic";
  domain = "midea_dehumidifier_lan";
  version = "0.9.4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-midea-air-appliances-lan";
    rev = "v${version}";
    hash = "sha256-Fl8qwsW9NdjnYdu7IGQDelXTLqNx5ioUoxkhv+p5L0I=";
  };

  propagatedBuildInputs = [ midea-beautiful-air ];

  meta = with lib; {
    description = "Home Assistant custom component adding support for controlling Midea air conditioners and dehumidifiers on local network";
    homepage = "https://github.com/nbogojevic/homeassistant-midea-air-appliances-lan";
    changelog = "https://github.com/nbogojevic/homeassistant-midea-air-appliances-lan/releases/tag/v${version}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
