# http://www.supermicro.com/products/motherboard/Atom/X10/A1SRi-2758F.cfm
#
# This board contains a TPM header, but you must supply your own module.
#

{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ipmitool ];
  boot.kernelModules = [ "ipmi_devintf" "ipmi_si" ];

  # The Linux NIC driver seems to have faulty link state reporting
  # that causes dhcpcd to release every few seconds, which is
  # more annoying than not releasing when a cable is unplugged.
  networking.dhcpcd.extraConfig = "nolink";
}
