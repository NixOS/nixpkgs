# http://www.supermicro.com/products/motherboard/Atom/X10/A1SRi-2758F.cfm
#
# This board contains a TPM header, but you must supply your own module.
#

{ pkgs, ... }:

{
  imports = [ ../lib/hardware-notes.nix ];

  environment.systemPackages = [ pkgs.ipmitool ];
  boot.kernelModules = [ "ipmi_devintf" "ipmi_si" ];

  networking.dhcpcd.extraConfig = "nolink";

  hardwareNotes =
    [ { title = "IPMI";
        text = "Load IPMI kernel modules and ipmitool to system environment.";
      }
      { title = "Nolink";
        text =
          ''
            Interface link state detection is disabled in dhcpcd because
            the Linux driver seems to send erronous loss of link messages
            that cause dhcpcd to release every few seconds, which is
            more annoying than not releasing when a cable is unplugged.
          '';
      }
    ];
}
