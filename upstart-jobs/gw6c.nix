{config, pkgs}:
let
        cfg = config.services.gw6c;
        procps = pkgs.procps;
        gw6cService = import ../services/gw6c {
                inherit (pkgs) stdenv gw6c coreutils 
                procps upstart iputils gnused 
                gnugrep seccureUser writeScript;
                username = cfg.username;
                password = cfg.password;
                server = cfg.server;
                keepAlive = cfg.keepAlive;
                everPing = cfg.everPing;

                seccureKeys = config.security.seccureKeys;

                waitPingableBroker = cfg.waitPingableBroker;
        };
in
{
        name = "gw6c";
        users = [];
        groups = [];
        job = "
description \"Gateway6 client\"

start on ${ if cfg.autorun then "network-interfaces/started" else "never" }
stop on network-interfaces/stop

respawn ${gw6cService}/bin/control start
";
}
