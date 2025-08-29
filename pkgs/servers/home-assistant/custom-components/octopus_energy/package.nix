{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pydantic,
  mock,
  nix-update-script,
}:
buildHomeAssistantComponent rec {
  owner = "BottlecapDave";
  domain = "octopus_energy";
  version = "16.0.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "HomeAssistant-OctopusEnergy";
    tag = "v${version}";
    hash = "sha256-/lhM00CNVPoZ8oohPuJ5j0pf0Dmxym3eycdkknlaAug=";
  };

  dependencies = [ pydantic ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    mock
  ];

  disabledTestPaths = [
    # Integration tests require a valid Octopus Energy API Key
    # https://github.com/BottlecapDave/HomeAssistant-OctopusEnergy/blob/develop/CONTRIBUTING.md#integration-tests
    "tests/integration"
    "tests/local_integration"

    # This unit test changes Home Assistant's default time zone to Europe/London
    # without restoring it, which fails pytest-homeassistant-custom-component's
    # teardown
    "tests/unit/utils/test_get_off_peak_cost.py::test_when_rates_available_and_bst_then_off_peak_cost_returned"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      # Ignore pre-release versions ("beta")
      "^v[0-9]+\\.[0-9]+\\.[0-9]+$"
    ];
  };

  meta = {
    changelog = "https://github.com/BottlecapDave/HomeAssistant-OctopusEnergy/releases/tag/v${version}";
    description = "Unofficial Home Assistant integration for interacting with Octopus Energy";
    homepage = "https://github.com/BottlecapDave/HomeAssistant-OctopusEnergy";
    maintainers = [ lib.maintainers.matteopacini ];
    license = lib.licenses.mit;
  };

}
