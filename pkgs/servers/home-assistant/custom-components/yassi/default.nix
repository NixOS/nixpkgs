{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pysmartthings,
}:

buildHomeAssistantComponent rec {
  owner = "samuelspagl";
  domain = "samsung_soundbar";
  version = "0.4.0b4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha_samsung_soundbar";
    rev = version;
    hash = "sha256-SwIB2w7iBFdyDfwm5WSDF59YVR8ou6Le0PLUMidS1vk=";
  };

  propagatedBuildInputs = [ pysmartthings ];

  meta = with lib; {
    description = "A HomeAssistant integration for Samsung Soundbars";
    homepage = "https://ha-samsung-soundbar.vercel.app/";
    changelog = "https://github.com/samuelspagl/ha_samsung_soundbar/releases/tag/${version}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
