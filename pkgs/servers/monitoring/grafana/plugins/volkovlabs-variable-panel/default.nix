{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-variable-panel";
  version = "4.1.0";
  zipHash = "sha256-3AkCebT9KcQdsi+T3+0XMhwZaEmqlOmY90RidcVqUb4=";
  meta = {
    description = "Variable panel allows you to have dashboard filters in a separate panel which you can place anywhere on the dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
