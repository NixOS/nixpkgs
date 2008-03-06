{avahi, config, writeText, lib}:

let

  avahiDaemonConf = with config; writeText "avahi-daemon.conf" ''
    [server]
    host-name=${hostName}
    browse-domains=${lib.concatStringsSep ", " browseDomains}
    use-ipv4=${if ipv4 then "yes" else "no"}
    use-ipv6=${if ipv6 then "yes" else "no"}

    [wide-area]
    enable-wide-area=${if wideArea then "yes" else "no"}

    [publish]
    disable-publishing=${if publishing then "no" else "yes"}
  '';

in

{
  name = "avahi-daemon";
  
  users = [
    { name = "avahi";
      uid = (import ../system/ids.nix).uids.avahi;
      description = "`avahi-daemon' privilege separation user";
      home = "/var/empty";
    }
  ];

  groups = [
    { name = "avahi";
      gid = (import ../system/ids.nix).gids.avahi;
    }
  ];

  job = ''
    start on startup
    stop on shutdown
    respawn
    script
      export PATH="${avahi}/bin:${avahi}/sbin:$PATH"
      exec ${avahi}/sbin/avahi-daemon --daemonize -f "${avahiDaemonConf}"
    end script
  '';

}
