{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "5.2.0";
  zipHash = "sha256-MzxKOJhDc0qogIPCnhf5bG/GcSzT6RbwYxU81Qj/NO8=";
  meta = {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
