{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pysmartthings,
}:

buildHomeAssistantComponent rec {
  owner = "samuelspagl";
  domain = "samsung_soundbar";
  version = "0.4.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha_samsung_soundbar";
    rev = version;
    hash = "sha256-uhyUQebAx4g1PT/urbyx8EZNFE9vIY0bUAKmgCwY3aQ=";
  };

  dependencies = [ pysmartthings ];

  meta = {
    description = "HomeAssistant integration for Samsung Soundbars";
    homepage = "https://ha-samsung-soundbar.vercel.app/";
    changelog = "https://github.com/samuelspagl/ha_samsung_soundbar/releases/tag/${version}";
    maintainers = with lib.maintainers; [ k900 ];
    license = lib.licenses.mit;
  };
}
