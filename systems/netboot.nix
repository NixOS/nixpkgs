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
                                boot.loader.grub.enable=false;
                                services.openmesh.xnode.admin = {
                                  enable = true;
                                  remoteDir = "https://dpl-backend-staging.up.railway.app/xnodes/functions";
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
                                  fsType = "tmpfs";
                                  options = [ "mode=0755" "size=80%" ];
                                };

                                "/nix/.ro-store" = {
                                  fsType = "squashfs";
                                  device = "/dev/loop0";
                                  options = [ "loop" ];
                                  neededForBoot = true;
                                };

                                "/nix/.rw-store" = {
                                  fsType = "tmpfs";
                                  options = [ "mode=0755" ];
                                  neededForBoot = true;
                                };

                                "/nix/store" = {
                                  neededForBoot = true;
                                  fsType = "overlay";
                                  device = "overlay";
                                  options = [
                                    "lowerdir=/nix/.ro-store"
                                    "upperdir=/nix/.rw-store/store"
                                    "workdir=/nix/.rw-store/work"
                                  ];
                                };

                              };

                              networking.useDHCP = lib.mkForce true;

                              boot.initrd = {
                                availableKernelModules = [
                                  # To mount /nix/store
                                  "squashfs"
                                  "overlay"
                                ];
                                kernelModules = [
                                  "loop"
                                  "overlay"
                                ];

                                network.enable = true;
                              };

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
