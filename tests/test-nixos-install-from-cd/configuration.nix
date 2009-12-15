# configuration being installed by NixOS kvm installation test
{pkgs, config, ...}: {

  # make system boot and accessible:
  require = [
    ./module-insecure.nix
  ];

  boot.loader.grub = {
    device = "/dev/sda";
    copyKernels = false;
    bootDevice = "(hd0,0)";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda1";
      neededForBoot = true;
    }
  ];

  swapDevices = [ { device = "/dev/sda2"; } ];

  fonts = {
    enableFontConfig = false; 
  };

}
