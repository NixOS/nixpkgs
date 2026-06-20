{
  lib,
  buildHomeAssistantComponent,
  ha-mcp,
  nix-update-script,
  ruamel-yaml,
}:

buildHomeAssistantComponent rec {
  domain = "ha_mcp_tools";
  inherit (ha-mcp) version src;
  inherit (ha-mcp.src) owner;

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
