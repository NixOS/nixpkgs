{
  beautifulsoup4,
  buildHomeAssistantComponent,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  hatchling,
  lib,
  nix-update-script,
  pydantic,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-socket,
  pyyaml,
  requests,
}:
let
  version = "3.14.0-beta.10";
  src = fetchFromGitHub {
    owner = "solentlabs";
    repo = "cable_modem_monitor";
    tag = "v${version}";
    hash = "sha256-Tl5MQVaitq1I5CeajVrgwKvs6HT4WEKejPjz2IcfTqw=";
    fetchLFS = true;
  };

  core = buildPythonPackage (finalAttrs: {
    inherit src version;
    pname = "solentlabs-cable-modem-monitor-core";
    pyproject = true;

    sourceRoot = "${finalAttrs.src.name}/packages/cable_modem_monitor_core";

    build-system = [ hatchling ];

    dependencies = [
      beautifulsoup4
      defusedxml
      pydantic
      pyyaml
      requests
    ];

    nativeCheckInputs = [
      cryptography
      pytestCheckHook
      pytest-cov-stub
      pytest-socket
    ];
  });

  catalog = buildPythonPackage (finalAttrs: {
    inherit src version;
    pname = "solentlabs-cable-modem-monitor-catalog";
    pyproject = true;

    sourceRoot = "${finalAttrs.src.name}/packages/cable_modem_monitor_catalog";

    build-system = [ hatchling ];

    dependencies = [
      core
    ];

    nativeCheckInputs = [
      cryptography
      pytestCheckHook
      pytest-socket
    ];
  });
in
buildHomeAssistantComponent rec {
  inherit src version;
  owner = "solentlabs";
  domain = "cable_modem_monitor";

  dependencies = [
    catalog
    core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    description = "Home Assistant integration for monitoring cable modem signal quality";
    homepage = "https://solentlabs.io/cable-modem-monitor";
    changelog = "https://github.com/solentlabs/cable_modem_monitor/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
}
