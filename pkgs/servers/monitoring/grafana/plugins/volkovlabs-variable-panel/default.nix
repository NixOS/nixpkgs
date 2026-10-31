{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
