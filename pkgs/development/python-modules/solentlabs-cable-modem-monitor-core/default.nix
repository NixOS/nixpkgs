{
  beautifulsoup4,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  hatchling,
  lib,
  nix-update-script,
  pydantic,
  pyyaml,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "solentlabs-cable-modem-monitor-core";
  version = "3.14.0-beta.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "solentlabs";
    repo = "cable_modem_monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-plSW3moR5Uf2cDSxeX9EjlT7+tQf51zBk/4JsJ0pNl0=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/cable_modem_monitor_core";

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    defusedxml
    pydantic
    pyyaml
    requests
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    description = "Modem config files and parser overrides";
    homepage = "https://solentlabs.io/cable-modem-monitor";
    changelog = "https://github.com/solentlabs/cable_modem_monitor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
})
