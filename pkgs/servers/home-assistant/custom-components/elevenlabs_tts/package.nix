{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "carleeno";
  domain = "elevenlabs_tts";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "carleeno";
    repo = "elevenlabs_tts";
    tag = version;
    hash = "sha256-/hszK5J1iGB46WfmCCK9/F0JOR405gplMwVC4niAqig=";
  };

  meta = {
    changelog = "https://github.com/carleeno/elevenlabs_tts/releases/tag/${version}";
    description = "Home Assistant Eleven Labs TTS Integration";
    homepage = "https://github.com/carleeno/elevenlabs_tts";
    maintainers = with lib.maintainers; [ mindstorms6 ];
    license = lib.licenses.asl20;
  };
}
