{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  rapidfuzz,
  # Test dependencies
  pytestCheckHook,
  pytest-asyncio,
  pyyaml,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "charludo";
  domain = "closest_intent";
  version = "0.2.1";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "hass-closest-intent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rfmQso2UJsyyCA5F+0B/7gszxy6+RUpTJtil0CxdtyY=";
  };

  dependencies = [
    rapidfuzz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pyyaml
  ];

  meta = {
    changelog = "https://github.com/charludo/hass-closest-intent/releases/tag/${finalAttrs.src.tag}";
    description = "Fuzzy intent matcher for Home Assistant; garbled STT output in, actual intent out";
    homepage = "https://github.com/charludo/hass-closest-intent";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      charludo
      jpds
    ];
  };
})
