{ inputs, ... }@flakeContext:
let
  pkgs = inputs.nixpkgs;
  netboot = { config, lib, pkgs, ... }: {
    imports = [
      ../repo/modules/services/openmesh/xnode/admin.nix
    ];
    config = {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nix.settings.trusted-users = [ "root" "xnode" "openmesh-xnode-admin" ];
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
              remoteDir = "https://dpl-staging.openmesh.network/xnodes/functions";
            };
          };
        };
        getty = {
          autologinUser = lib.mkForce "xnode";
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
        postBootCommands = ''
                            cat > /etc/nixos/configuration.nix <<ENDFILE
                            {config, lib, pkgs, ...}:{
                              imports=[./hardware-configuration.nix] ++ lib.optional (builtins.pathExists /var/lib/openmesh-xnode-admin/config.nix) /var/lib/openmesh-xnode-admin/config.nix ++ lib.optional (builtins.pathExists /var/lib/openmesh-xnode-admin/xnodeos) /var/lib/openmesh-xnode-admin/xnodeos/repo/modules/services/openmesh/xnode/admin.nix ;
                              config = {
                                nix.settings.experimental-features = [ "nix-command" "flakes" ];
                                nix.settings.trusted-users = [ "root" "xnode" "openmesh-xnode-admin" ];
                                boot.loader.grub.enable=false;
                                nixpkgs.config.allowUnfree = true;
                                services.openmesh.xnode.admin = {
                                  enable = true;
                                  remoteDir = "https://dpl-staging.openmesh.network/xnodes/functions";
                                };
                                users.users = {
                                  "xnode" = {
                                    isNormalUser = true;
                                    password = "xnode";
                                    extraGroups = [ "wheel" ];
                                  };
                                };
                              };
                            }
                            ENDFILE

                            cat > /etc/nixos/hardware-configuration.nix <<ENDFILE
                            {config, lib, pkgs, modulesPath, ...}: {
                              fileSystems = {
                                "/" = {
                                  device = "none";
                                  fsType = "tmpfs";
                                };
                              };

                              networking.useDHCP = lib.mkForce true;
                              nixpkgs.hostPlatform=lib.mkDefault "x86_64-linux";
                            }
                            ENDFILE
                          '';
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
