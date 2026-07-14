{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  sympy,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "skye-harris";
  domain = "llm_intents";
  version = "1.8.2";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "llm_intents";
    tag = finalAttrs.version;
    hash = "sha256-UYWt+PpG0M1DE1nHqLJ/npp29JyfNz19Pyb1Jv3LM48=";
  };

  dependencies = [
    sympy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/skye-harris/llm_intents/releases/tag/${finalAttrs.src.tag}";
    description = "Exposes internet search tools for use by LLM-backed Assist in Home Assistant";
    homepage = "https://github.com/skye-harris/llm_intents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpds ];
  };
})
