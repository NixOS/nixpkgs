{pkgs, config}:

assert config.services.openfire.usePostgreSQL -> config.services.postgresql.enable;
let
  startDependency = if config.services.openfire.usePostgreSQL then 
    "postgresql"
  else
    if config.services.gw6c.enable then 
      "gw6c" 
    else 
      "network-interfaces";
in
with pkgs;
{
  name = "openfire";
  job = ''
    description "OpenFire XMPP server"

    start on ${startDependency}/started
    stop on shutdown

    script 
      export PATH=${jre}/bin:${openfire}/bin:${coreutils}/bin:${which}/bin:${gnugrep}/bin:${gawk}/bin:${gnused}/bin
      export HOME=/tmp
      openfire start
    end script
  '';
}
