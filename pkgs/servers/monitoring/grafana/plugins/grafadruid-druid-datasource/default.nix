{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafadruid-druid-datasource";
  version = "1.4.1";
  zipHash = "sha256-7atxqRqKqop6ABQ+ead6wR/YRpJaV8j/Ri4VB9FXMu8=";
  meta = with lib; {
    description = "Connects Grafana to Druid";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
    platforms = platforms.unix;
  };
}
