{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  cachetools,
  meshcore,
  meshcore-cli,
  paho-mqtt,
  pynacl,
  pytest-asyncio,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "meshcore-dev";
  domain = "meshcore";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K1DYBcuAilcKBzQVSUQvoA9OoxUbtfISYNY8IwgUdZk=";
  };

  dependencies = [
    cachetools
    meshcore
    meshcore-cli
    paho-mqtt
    pynacl
  ];

  ignoreVersionRequirement = [
    "meshcore"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/meshcore-dev/meshcore-ha/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant integration for MeshCore";
    homepage = "https://github.com/meshcore-dev/meshcore-ha/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
})
