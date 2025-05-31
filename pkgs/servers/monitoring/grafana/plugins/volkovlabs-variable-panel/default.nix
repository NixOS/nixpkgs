{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "3.9.0";
  zipHash = "sha256-M9upfNMK45dPnouSO6Do3Li833q9NI0H2gc6DaLEsbA=";
  meta = with lib; {
    description = "The Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
