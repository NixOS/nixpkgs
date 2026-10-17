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
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "mbillow";
    repo = "localthings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kTeoVtKiwud18xnHvkAZ1BgFmWPOsjGtq1sZV5EiunI=";
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

  disabledTests = [
    "test_a_push_that_will_not_decode_is_kept_raw"
  ];

  meta = {
    changelog = "https://github.com/mbillow/localthings/releases/tag/${finalAttrs.src.tag}";
    description = "Local-control Home Assistant component that authenticates to newer-firmware Samsung devices and talks over CoAP-DTLS";
    homepage = "https://github.com/mbillow/localthings";
    maintainers = with lib.maintainers; [ Scrumplex ];
    license = lib.licenses.mit;
  };
})
