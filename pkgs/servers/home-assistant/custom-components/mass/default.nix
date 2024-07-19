{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, toPythonModule
, async-timeout
, music-assistant
}:

buildHomeAssistantComponent rec {
  owner = "music-assistant";
  domain = "mass";
  version = "2024.6.2";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "hass-music-assistant";
    rev = version;
    hash = "sha256-Wvc+vUYkUJmS4U34Sh/sDCVXmQA0AtEqIT8MNXd++3M=";
  };

  dependencies = [
    async-timeout
    (toPythonModule music-assistant)
  ];

  dontCheckManifest = true; # expects music-assistant 2.0.6, we have 2.0.7

  meta = with lib; {
    description = "Turn your Home Assistant instance into a jukebox, hassle free streaming of your favorite media to Home Assistant media players";
    homepage = "https://github.com/music-assistant/hass-music-assistant";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
