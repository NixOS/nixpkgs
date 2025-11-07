{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-rss-datasource";
  version = "4.4.0";
  zipHash = "sha256-0/B5E1DSjVq9e+1FAFw0J3Kuc7oud6apP9b07icg1Hk=";
  meta = with lib; {
    description = "Plugin for Grafana that retrieves RSS/Atom feeds and allows visualizing them using Dynamic Text and other panels";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
