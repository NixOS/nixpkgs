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
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${version}";
    hash = "sha256-qRWNh7kKFQZpgZjkpc/Qv2s16DdWFX35HLHIToYXccU=";
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
