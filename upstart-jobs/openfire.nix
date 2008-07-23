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
      mkdir /var/log/openfire || true 
      mkdir /etc/openfire || true 
      for i in ${openfire}/conf.inst/*; do
          if ! test -f /etc/openfire/$(basename $i); then
              cp $i /etc/openfire/
          fi
      done
      openfire start
    end script
  '';
}
