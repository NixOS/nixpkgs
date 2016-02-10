{ pkgs, config, lib, ... }:
{
  nix.binaryCaches = lib.mkForce [ "http://nixos-arm.dezgeg.me/channel" ];
  nix.binaryCachePublicKeys = [ "nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%" ];
  nixpkgs.config.packageOverrides = pkgs: rec {
    linuxPackages_usbarmory = pkgs.recurseIntoAttrs (
      pkgs.linuxPackagesFor (
        pkgs.buildLinux rec {
          version = "4.4.0";
          src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v4.x/linux-4.4.tar.xz";
             sha256 = "401d7c8fef594999a460d10c72c5a94e9c2e1022f16795ec51746b0d165418b2";
          };
          configfile = /etc/nixos/customKernel.config;
          kernelPatches = [
            { patch = /etc/nixos/usbarmory_dts.patch;
              name = "usbarmory_dts"; }
          ];
          allowImportFromDerivation = true;
        }
      ) linuxPackages_usbarmory);
  };
  boot = {
    initrd.kernelModules = [];
    kernelParams =  [ "console=ttymxc0,115200" ];
    kernelModules = [ "ledtrig_heartbeat" "ci_hdrc_imx" "g_ether" ];
    extraModprobeConfig = "options g_ether use_eem=0 dev_addr=1a:55:89:a2:69:41 host_addr=1a:55:89:a2:69:42";
    kernelPackages = pkgs.linuxPackages_usbarmory;

    loader = {
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
      };
    };
  };
  networking = {
    interfaces.usb0.ip4 = [ { address = "172.16.0.2"; prefixLength = 24;} ];
    hostName = "usbarmory";
    defaultGateway = "172.16.0.1";
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
};
  sound.enable = false;
  services = {
    nixosManual.enable = false;
    openssh.enable = true;
    openssh.permitRootLogin = "without-password";
  };
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/NIXOS_BOOT";
        fsType = "vfat";
      };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };

}
