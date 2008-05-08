{pkgs, config}:

let

  cfg = config.services.dhcpd;

  stateDir = "/var/lib/dhcp"; # Don't use /var/state/dhcp; not FHS-compliant.

  machines = pkgs.lib.concatMapStrings (machine: ''
    host ${machine.hostName} {
      hardware ethernet ${machine.ethernetAddress};
      fixed-address ${machine.ipAddress};
    }
  '') cfg.machines;

  configFile = if cfg.configFile != null then cfg.configFile else pkgs.writeText "dhcpd.conf" ''
    default-lease-time 600;
    max-lease-time 7200;
    authoritative;
    ddns-update-style ad-hoc;
    log-facility local1; # see dhcpd.nix
    ${cfg.extraConfig}
    ${machines}
  '';

in
  
{
  name = "dhcpd";
  
  job = ''
    description "DHCP server"

    start on network-interfaces/started
    stop on network-interfaces/stop

    script

        mkdir -m 755 -p ${stateDir}

        touch ${stateDir}/dhcpd.leases

        exec ${pkgs.dhcp}/sbin/dhcpd -f -cf ${configFile} \
            -lf ${stateDir}/dhcpd.leases \
            ${toString cfg.interfaces}

    end script
  '';
  
}
