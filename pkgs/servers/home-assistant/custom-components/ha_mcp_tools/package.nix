{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "homeassistant-ai";
  domain = "ha_mcp_tools";
  version = "6.6.1";

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${version}";
    hash = "sha256-yAJbvfIH5ewRTip8whbOKxE479qAihESaiLFTnhpRkY=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  meta = {
    changelog = "https://github.com/homeassistant-ai/ha-mcp/releases/tag/v${version}";
    description = "Home Assistant custom component for the MCP (Model Context Protocol) server";
    homepage = "https://github.com/homeassistant-ai/ha-mcp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
