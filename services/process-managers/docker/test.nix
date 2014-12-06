{ config, pkgs, ... }:

{
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql;
  services.mongodb.enable = true;
  sal.docker.containers.postgresql.redirects.mongodb.port = 10000;
}
