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
  version = "0.1.21";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "QuiteYellow";
    repo = "SmartThings-Local";
    tag = "v${finalAttrs.version}";
    hash = "sha256-coLCgFTu//mWt7XZsrvXSUBg2dwn/mHq4EJTW+NhWpo=";
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
    # timezone handling issues
    # assert 'GMT' in "clock sync (periodic) skipped: host clock reads 2000-01-01T00:00:00 Europe, outside the plausible window -- writing it could break the appliance's certificate verification"
    "test_a_skipped_write_names_the_zone_too"
    # AssertionError: assert '14:30:05 BST ->' in 'clock sync (periodic) /configuration/vs/0 = 2026-09-08T14:30:05 Europe -> 2.04'
    "test_the_log_line_names_the_zone_the_stamp_came_from"
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
