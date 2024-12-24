{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-variable-panel";
  version = "3.5.0";
  zipHash = "sha256-SqMTCdB+8OUo94zJ3eS5NoCeyjc7sdMCR0CTvVe/L1g=";
  meta = with lib; {
    description = "The Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
