{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "4.0.0";
  zipHash = "sha256-fHOo/Au8yPQXIkG/BupNcMpFNgDLRrqpwRpmbq6xYhM=";
  meta = {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
