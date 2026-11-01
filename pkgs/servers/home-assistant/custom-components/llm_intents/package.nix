{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  wikipedia-api,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "skye-harris";
  domain = "llm_intents";
  version = "1.11.1";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "llm_intents";
    tag = finalAttrs.version;
    hash = "sha256-xXyFUR20hovYVM5YgvwvghNVv2Zpex8kK1ZsQQ5kVvs=";
  };

  dependencies = [
    wikipedia-api
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTestPaths = [
    # API break
    # HomeControlAPI._async_get_api_prompt() takes 2 positional arguments but 3 were given
    "tests/test_home_control.py"
  ];

  meta = {
    changelog = "https://github.com/skye-harris/llm_intents/releases/tag/${finalAttrs.src.tag}";
    description = "Exposes internet search tools for use by LLM-backed Assist in Home Assistant";
    homepage = "https://github.com/skye-harris/llm_intents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpds ];
  };
})
