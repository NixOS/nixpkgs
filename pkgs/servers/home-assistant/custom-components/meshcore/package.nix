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
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "meshcore-dev";
  domain = "meshcore";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G1mrYz40Z4Lrk5OBhk2i3knYA+tjfDFXYQibn2E5Y+A=";
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
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  # https://github.com/meshcore-dev/meshcore-ha/issues/363
  doCheck = false;

  meta = {
    changelog = "https://github.com/meshcore-dev/meshcore-ha/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant integration for MeshCore";
    homepage = "https://github.com/meshcore-dev/meshcore-ha/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
})
