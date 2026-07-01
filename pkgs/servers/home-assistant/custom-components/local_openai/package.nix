{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  openai,
  demoji,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "skye-harris";
  domain = "local_openai";
  version = "1.8.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "hass_local_openai_llm";
    tag = finalAttrs.version;
    hash = "sha256-L5gcjKTT9KvTHCuUxg+r0mBJ+jRZqLvF9o+X+6tSH6g=";
  };

  dependencies = [
    openai
    demoji
  ];

  meta = {
    changelog = "https://github.com/skye-harris/hass_local_openai_llm/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant LLM integration for local OpenAI-compatible services (llama.cpp, vLLM, etc.)";
    homepage = "https://github.com/skye-harris/hass_local_openai_llm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
  };
})
