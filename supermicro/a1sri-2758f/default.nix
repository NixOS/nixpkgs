# http://www.supermicro.com/products/motherboard/Atom/X10/A1SRi-2758F.cfm
#
# This board contains a TPM header, but you must supply your own module.
#

{ pkgs, lib, ... }:

{
  imports = [ ../lib/kernel-version.nix ];

  environment.systemPackages = [ pkgs.ipmitool ];
  boot.kernelModules = [ "ipmi_devintf" "ipmi_si" ];

  kernelAtleast = lib.singleton
    { version = "4.4";
      msg =
        "ethernet driver may be buggy on older kernels, "+
        ''try 'networking.dhcpcd.extraConfig = "nolink";' if you encounter loss of link problems'';
    };
}
