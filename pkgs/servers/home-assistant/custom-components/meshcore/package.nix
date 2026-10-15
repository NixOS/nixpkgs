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
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eshYgWo37lxTJJiRKMMlIYZsKtjXr7GjKhywH4ABPao=";
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
