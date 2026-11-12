{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python-miio,
}:

buildHomeAssistantComponent rec {
  owner = "ee02217";
  domain = "miheater";
  version = "2.1.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-mi-heater";
    tag = version;
    hash = "sha256-NyIToqXOUUG2aitAyz1Xbh1NQsoTRNK6OSw+i1Rwz1I=";
  };

  dependencies = [
    python-miio
  ];

  meta = {
    description = "Home Assistant integration for MiHeaters";
    homepage = "https://github.com/ee02217/homeassistant-mi-heater";
    changelog = "https://github.com/ee02217/homeassistant-mi-heater/releases/tag/${version}";
    maintainers = with lib.maintainers; [ baksa ];
  };
}
