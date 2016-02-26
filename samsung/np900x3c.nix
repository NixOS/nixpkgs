{ lib, ... }:
with lib;
{
  imports = [ ../lib/kernel-version.nix ];

  services.xserver.synaptics.enable = true;

  kernelAtleast = singleton
    { version = "3.9";
      msg = "Runtime system freezes can be expected on Linux kernels prior to 3.9, probably  because of bugs in intel video drivers.";
    };

}