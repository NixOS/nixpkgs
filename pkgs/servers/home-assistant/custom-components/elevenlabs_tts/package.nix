{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "carleeno";
  domain = "elevenlabs_tts";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "carleeno";
    repo = "elevenlabs_tts";
    rev = "refs/tags/${version}";
    hash = "sha256-7/Di3K7b0IzxatqBXqgVeMziRwalOVmIJ5IuEWJVjkE=";
  };

  meta = with lib; {
    changelog = "https://github.com/carleeno/elevenlabs_tts/releases/tag/${version}";
    description = "Home Assistant Eleven Labs TTS Integration";
    homepage = "https://github.com/carleeno/elevenlabs_tts";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.asl20;
  };
}
