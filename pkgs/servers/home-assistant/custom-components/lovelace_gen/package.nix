{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  jinja2,
}:

buildHomeAssistantComponent rec {
  owner = "thomasloven";
  domain = "lovelace_gen";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "hass-lovelace_gen";
    tag = version;
    hash = "sha256-YGqvdoOs9/Etfldoee3mgDQjtveLa/LovwX/IduYyjg=";
  };

  dependencies = [ jinja2 ];

  meta = with lib; {
    changelog = "https://github.com/thomasloven/hass-lovelace_gen/releases/tag/${version}";
    description = "Improve the lovelace yaml parser for Home Assistant";
    homepage = "https://github.com/thomasloven/hass-lovelace_gen";
    license = licenses.mit;
    maintainers = with maintainers; [ jpinz ];
  };
}
