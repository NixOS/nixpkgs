{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  jinja2,
}:

buildHomeAssistantComponent rec {
  owner = "thomasloven";
  domain = "lovelace_gen";
  version = "6";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "hass-lovelace_gen";
    tag = version;
    hash = "sha256-GYchomeY9NuQXqBWC0y1G/a+aYTIseatF6UHi/6wN9Q=";
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
