{ config, pkgs, ... }:

{
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql;
  services.postgresql.port = 65100;
  services.elasticsearch.enable = true;
  services.influxdb.enable = true;
  services.nginx.enable = true;
  services.logstash.enable = true;
  services.logstash.enableWeb = true;
  services.graphite.api.enable = true;
  services.graphite.seyren.enable = true;
}
