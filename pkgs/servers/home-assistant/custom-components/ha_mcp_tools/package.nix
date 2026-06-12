{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
  ruamel-yaml,
}:

buildHomeAssistantComponent rec {
  owner = "homeassistant-ai";
  domain = "ha_mcp_tools";
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${version}";
    hash = "sha256-Gp4C3SRNkgv9GfLkVx/VCMp4/kCORHsp87IHcCaCPKk=";
  };

  dependencies = [
    ruamel-yaml
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = {
    changelog = "https://github.com/homeassistant-ai/ha-mcp/releases/tag/v${version}";
    description = "Home Assistant custom component for the MCP (Model Context Protocol) server";
    homepage = "https://github.com/homeassistant-ai/ha-mcp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
