{ lib, ... }:

{
  services.xserver.synaptics.enable = lib.mkDefault true;
}
