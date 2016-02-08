# http://www.supermicro.com/products/motherboard/Atom/X10/A1SRi-2758F.cfm

{ ... }:

{
  # The Linux NIC driver doesn't properly report link status.
  networking.dhcpcd.extraConfig = "nolink";
}
