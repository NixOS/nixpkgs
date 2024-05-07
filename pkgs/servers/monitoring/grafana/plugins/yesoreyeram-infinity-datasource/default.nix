
{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  version = "2.8.0";
  zipHash = {
    x86_64-linux = "sha256-xVn7YRHpu6jy7AC/1fdpnbElwdwZhbUc2dVoWEU9Hu8=";
    aarch64-linux = "sha256-cqSPgR2g8M1kCVNpAozBap1yuSpoDLbCxhDJGNMWPp4=";
    x86_64-darwin = "sha256-3IUa6x1RsoapVBZ6ECSuhbSUoKuVlgojX2g05H4/sxk=";
    aarch64-darwin = "sha256-d4Boud28ZgBkKZfKMB1hgWTG0iJijqsfuMJI09wnNFY=";
  };
  meta = with lib; {
    description = "CSV, JSON, GraphQL, XML and HTML datasource for grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ newam pamplemousse ];
    platforms = platforms.unix;
  };
}
