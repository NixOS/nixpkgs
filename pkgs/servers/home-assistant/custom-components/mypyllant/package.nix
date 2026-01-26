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

buildHomeAssistantComponent rec {
  owner = "signalkraft";
  domain = "mypyllant";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "mypyllant-component";
    tag = "v${version}";
    hash = "sha256-wkUz5pPO50yfWbZBa+Z+9WKIZKCJhJVn8/HlzZwSZVY=";
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
    changelog = "https://github.com/signalkraft/mypyllant-component/releases/tag/${src.tag}";
    homepage = "https://github.com/signalkraft/mypyllant-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
}
