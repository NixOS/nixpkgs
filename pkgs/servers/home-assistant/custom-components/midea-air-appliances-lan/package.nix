{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  midea-beautiful-air,
}:

buildHomeAssistantComponent rec {
  owner = "nbogojevic";
  domain = "midea_dehumidifier_lan";
  version = "0.9.7";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-midea-air-appliances-lan";
    rev = "v${version}";
    hash = "sha256-Rya1mP4KcKA2ZZ16DpxOgXN7NA4Iv0q7PgS+fV5vZq0=";
  };

  dependencies = [ midea-beautiful-air ];

  meta = {
    description = "Home Assistant custom component adding support for controlling Midea air conditioners and dehumidifiers on local network";
    homepage = "https://github.com/nbogojevic/homeassistant-midea-air-appliances-lan";
    changelog = "https://github.com/nbogojevic/homeassistant-midea-air-appliances-lan/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ k900 ];
    license = lib.licenses.mit;
  };
}
