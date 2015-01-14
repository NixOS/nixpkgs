{ config, pkgs, ... }:

{
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql;
  services.postgresql.port = 65100;
  services.mongodb.enable = true;
}
