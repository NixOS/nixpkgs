/** imported from https://nixos.org/wiki/Raspberry_Pi_2 **

# Status
The code in master as of June 2015 should be able to prepare a bootable NixOS for Raspberry PI 2.

There are still some drawbacks:

NixOS does not provide a /boot/config.txt (the FAT32 partition).
Making NixOS work in the Raspberry PI 2 is mainly the result of the recent work of ambro718, Dezgeg and viric (#nixos@irc.freenode.net).

# Download
If you want to test, you can flash this 4GB SD image (DOS partition table + fat32 + ext4 rootfs):
magnet:?xt=urn:btih:0def3f6acb3bceddb22cb24098f58e40e2853ec2&dn=rpi2-nixos-4b09501f2-img.xz&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80

Then you should be able to nixos-rebuild any configuration.nix changes.

The image is the result of a "nixos-install" alone. No root password has been set, and it does not include a nixpkgs checkout or channel.

In fact I (viric) created the FS into a NBD, not a real SD, to create this image.

*/

{ pkgs, config, lib, ...}:

{
  boot.consoleLogLevel = 7;
  boot.loader.grub.enable = false;
  boot.loader.generationsDir.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 2;
  boot.extraTTYs = [ "ttyAMA0" ];
  boot.kernelPackages = pkgs.linuxPackages_rpi;
  boot.kernelParams = [
    #"coherent_pool=6M"
    #"smsc95xx.turbo_mode=N"
    "dwc_otg.lpm_enable=0"
    "console=ttyAMA0,115200"
    "rootwait"
    #"console=tty1"
    "elevator=deadline"
  ];

  # cpufrequtils doesn't build on ARM
  powerManagement.enable = false;

  services.xserver.enable = false;
  services.openssh.enable = true;

  services.nixosManual.enable = false;

  nixpkgs.config = {
    # Since https://github.com/NixOS/nixpkgs/commit/f0b634c7e838cdd65ac6f73933c99af3f38d0fa8
    nixpkgs.config.platform = lib.systems.platforms.raspberrypi2;
    # Earlier than that, use this:
    # platform = pkgs.platforms.raspberrypi2;
    # Also be aware of this issue if you're encountering infinite recursion:
    # https://github.com/NixOS/nixpkgs/issues/24170

    allowUnfree = true;
  };

  nix.buildCores = 4;
  nix.binaryCaches = [ ];
}
