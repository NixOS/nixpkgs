{ callPackage }:

{
  check_esxi_hardware = callPackage ./check_esxi_hardware { };
  check_interfaces = callPackage ./check_interfaces { };
  check_openvpn = callPackage ./check_openvpn { };
  check_smartmon = callPackage ./check_smartmon { };
  check_ssl_cert = callPackage ./check_ssl_cert { };
  check_systemd = callPackage ./check_systemd { };
  check_uptime = callPackage ./check_uptime { };
  check_wmi_plus = callPackage ./check_wmi_plus { };
  check_zfs = callPackage ./check_zfs { };

  inherit (callPackage ./labs_consol_de { }) check_mssql_health check_nwc_health check_ups_health;
  manubulon-snmp-plugins = callPackage ./manubulon-snmp-plugins { };
  openbsd_snmp3_check = callPackage ./openbsd_snmp3_check { };
}
