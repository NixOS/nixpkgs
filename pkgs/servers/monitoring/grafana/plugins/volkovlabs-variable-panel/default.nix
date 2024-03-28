{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-variable-panel";
  version = "2.3.1";
  zipHash = "sha256-LlgaDUl/4E/UpW8uOfzs4s8hevbZlg6zNgq1Pm/0zrE=";
  meta = with lib; {
    description = "The Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
