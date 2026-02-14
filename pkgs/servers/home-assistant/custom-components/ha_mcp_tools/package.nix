{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "homeassistant-ai";
  domain = "ha_mcp_tools";
  version = "6.6.1.dev206";

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${version}";
    hash = "sha256-M+jW/uv+hgueiEpi1zO4RSSi3kyQK4X9M/HOBo56S9c=";
  };

  meta = {
    changelog = "https://github.com/homeassistant-ai/ha-mcp/releases/tag/v${version}";
    description = "Home Assistant custom component for the MCP (Model Context Protocol) server";
    homepage = "https://github.com/homeassistant-ai/ha-mcp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
