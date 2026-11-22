{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,

  # dependencies
  mypyllant,
  voluptuous,

  # tests
  aioresponses,
  polyfactory,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-xdist,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "signalkraft";
  domain = "mypyllant";
  version = "0.9.19";

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "mypyllant-component";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+KHmsgfGPIIWu+TTumswcaEoyQF9KvBVAKNGtNhZuQ=";
  };

  dependencies = [
    mypyllant
    voluptuous
  ];

  nativeCheckInputs = [
    aioresponses
    polyfactory
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    description = "Unofficial Home Assistant integration for interacting with myVAILLANT";
    changelog = "https://github.com/signalkraft/mypyllant-component/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/signalkraft/mypyllant-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
})
