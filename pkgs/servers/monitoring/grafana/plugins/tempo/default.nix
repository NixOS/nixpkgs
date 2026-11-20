{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "tempo";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Support for tempo data-source";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
