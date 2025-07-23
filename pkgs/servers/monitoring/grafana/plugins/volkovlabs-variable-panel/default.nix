{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "4.0.0";
  zipHash = "sha256-fHOo/Au8yPQXIkG/BupNcMpFNgDLRrqpwRpmbq6xYhM=";
  meta = with lib; {
    description = "The Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
