{
  lib,
  buildHomeAssistantComponent,
  ha-mcp,
  nix-update-script,
  ruamel-yaml,
}:

buildHomeAssistantComponent {
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
    inherit (ha-mcp.meta)
      changelog
      homepage
      license
      maintainers
      ;
    description = "Home Assistant custom component for the MCP (Model Context Protocol) server";
  };
}
