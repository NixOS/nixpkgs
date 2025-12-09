{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "5.1.1";
  zipHash = "sha256-lLzOCgOh4a/Ee6QO5gJkJkHoPzylk9Y3vilXBtvn5G8=";
  meta = with lib; {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
