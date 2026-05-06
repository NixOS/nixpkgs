{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  nix-update-script,
  solentlabs-cable-modem-monitor-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "solentlabs-cable-modem-monitor-catalog";
  version = "3.14.0-beta.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "solentlabs";
    repo = "cable_modem_monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-plSW3moR5Uf2cDSxeX9EjlT7+tQf51zBk/4JsJ0pNl0=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/cable_modem_monitor_catalog";

  build-system = [ hatchling ];

  dependencies = [
    solentlabs-cable-modem-monitor-core
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    description = "Platform-agnostic DOCSIS monitoring engine";
    homepage = "https://solentlabs.io/cable-modem-monitor";
    changelog = "https://github.com/solentlabs/cable_modem_monitor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
})
