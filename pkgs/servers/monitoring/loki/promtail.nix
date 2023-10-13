{ lib, grafana-loki }:

grafana-loki.overrideAttrs (prev: {
  pname = "promtail";
  subPackages = ["clients/cmd/promtail"];
})
