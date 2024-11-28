{ grafana-loki }:

grafana-loki.overrideAttrs (o: {
  pname = "promtail";
  subPackages = [ "clients/cmd/promtail" ];
  env.CGO_ENABLED = 1;
})
