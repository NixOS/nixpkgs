{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pytestCheckHook,
  sentence-stream,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "sfortis";
  domain = "openai_tts";
  version = "3.9.1";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "openai_tts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hpGKSUMJuW2XSAGuqmCIXTtN4Qh2nwOFJWAg5X9JljA=";
  };

  dependencies = [ sentence-stream ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Custom TTS component for Home Assistant. Utilizes the OpenAI speech engine or any compatible endpoint to deliver high-quality speech";
    longDescription = ''
      OpenAI TTS for Home Assistant depends on ffmpeg component, example how to setup in NixOS `configuration.nix`:

      ```
      { pkgs, ... }:
      {
        services.home-assistant = {
          customComponents = [ pkgs.home-assistant-custom-components.openai-tts ];
          extraComponents = [ "ffmpeg" ];
        };
      }
      ```
    '';
    homepage = "https://github.com/sfortis/openai_tts";
    changelog = "https://github.com/sfortis/openai_tts/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.gpl3Only;
  };
})
