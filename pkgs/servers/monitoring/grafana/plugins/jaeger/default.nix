{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "jaeger";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Support for Jaeger traces";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
