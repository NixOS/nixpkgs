{ inputs, ... }@flakeContext:
let
  netboot = { config, lib, pkgs, ... }: {
    imports = [
      ../repo/modules/services/openmesh/xnode/admin.nix
    ];
    config = {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      documentation = {
        nixos = {
          enable = false;
        };
        doc = {
          enable = false;
        };
      };
      services = {
        openmesh = {
          xnode = {
            admin = {
              enable = true;
              remoteDir = "https://dpl-backend-staging.up.railway.app/xnodes/functions";
            };
          };
        };
        getty = {
          greetingLine = ''<<< Welcome to Openmesh XnodeOS ${config.system.nixos.label} (\m) - \l >>>'';
        };
      };
      environment = {
        systemPackages = with pkgs; [
          nyancat
        ];
      };
      netboot = {
        squashfsCompression = "gzip -Xcompression-level 1";
      };
      boot = {
        postBootCommands = ''echo '{config,lib,pkgs,...}:{imports=[./hardware-configuration.nix] ++ lib.optional (builtins.pathExists /var/lib/openmesh-xnode-admin/config.nix) /var/lib/openmesh-xnode-admin/config.nix; boot.loader.grub.enable=false;}' > /etc/nixos/configuration.nix && echo '{config,lib,pkgs,modulesPath,...}:{fileSystems."/"={device="tmpfs";fsType="tmpfs";};nixpkgs.hostPlatform=lib.mkDefault "x86_64-linux";}' > /etc/nixos/hardware-configuration.nix'';
      };
      networking = {
        hostName = "xnode";
      };
      users = {
        users = {
          xnode = {
            isNormalUser = true;
            password = "xnode";
            extraGroups = [ "wheel" ];
          };
        };
      };
    };
  };
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  customFormats = { "netboot" = import ./custom-formats/netboot.nix; };
  format = "netboot";
  modules = [
    netboot
  ];
}
