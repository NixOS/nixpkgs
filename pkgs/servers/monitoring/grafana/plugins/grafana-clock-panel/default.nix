{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clock-panel";
  version = "1.1.3";
  zipHash = "sha256-80JaMhY/EduSWvFrScfua99DGhT/FJUqY/kl0CafKCs=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
