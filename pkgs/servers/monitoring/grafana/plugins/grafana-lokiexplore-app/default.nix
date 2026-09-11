{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "2.5.2";
  zipHash = "sha256-MVqubd7CpUhUeFahvYhGUVB9ouGC81gZGYg3n2Ui0F0=";
  meta = {
    description = "Browse Loki logs without the need for writing complex queries";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
