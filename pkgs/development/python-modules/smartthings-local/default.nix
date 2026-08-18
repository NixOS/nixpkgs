{
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  git,
  hatch-vcs,
  hatchling,
  lib,
  nix-update-script,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "smartthings-local";
  version = "0.1.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "QuiteYellow";
    repo = "SmartThings-Local";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gTHcMz3wA877DMgXyv9VatD2O7iNJ/rpkgli327njjY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    cbor2
    pyopenssl
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    # import can't find pyopenssl for some reason
    "test_smartthings_local_imports_without_mqtt_demo_present"
  ];

  pythonImportsCheck = [
    "smartthings_local"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local control of Samsung SmartThings appliances over cert-authenticated CoAP-DTLS. No cloud! Python library + Home Assistant MQTT bridge demo";
    homepage = "https://github.com/QuiteYellow/SmartThings-Local";
    changelog = "https://github.com/QuiteYellow/SmartThings-Local/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
})
