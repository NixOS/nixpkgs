{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "5.1.1";
  zipHash = "sha256-lLzOCgOh4a/Ee6QO5gJkJkHoPzylk9Y3vilXBtvn5G8=";
  meta = {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
