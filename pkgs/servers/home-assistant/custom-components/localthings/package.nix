{
  buildHomeAssistantComponent,
  cbor2,
  fetchFromGitHub,
  lib,
  pyopenssl,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
  smartthings-local,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "mbillow";
  domain = "localthings";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "mbillow";
    repo = "localthings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aRmKp+1M8QaMe3xBp8FcdNRPgI8faW+7870K2ffLCwY=";
  };

  dependencies = [
    cbor2
    pyopenssl
    smartthings-local
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/mbillow/localthings/releases/tag/${finalAttrs.src.tag}";
    description = "Local-control Home Assistant component that authenticates to newer-firmware Samsung devices and talks over CoAP-DTLS";
    homepage = "https://github.com/mbillow/localthings";
    maintainers = with lib.maintainers; [ Scrumplex ];
    license = lib.licenses.mit;
  };
})
