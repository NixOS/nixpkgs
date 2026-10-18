{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "prometheus";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Support for prometheus data-source";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
