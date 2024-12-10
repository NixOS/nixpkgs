{ lib, grafana-loki }:

grafana-loki.overrideAttrs (o: {
  pname = "promtail";
  subPackages = [ "clients/cmd/promtail" ];
  CGO_ENABLED = 1;
})
