{ inputs, ... }@flakeContext:
let
  kexec = { config, lib, pkgs, ... }: {
    imports = [
      ../repo/modules/services/openmesh/xnode/admin.nix
    ];
    config = {
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
      kexec = {
        squashfsCompression = "gzip -Xcompression-level 1";
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
  format = "kexec";
  modules = [
    kexec
  ];
}
