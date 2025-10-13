{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "4.1.0";
  zipHash = "sha256-3AkCebT9KcQdsi+T3+0XMhwZaEmqlOmY90RidcVqUb4=";
  meta = with lib; {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
