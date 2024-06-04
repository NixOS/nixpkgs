{ inputs, ... }@flakeContext:
let
  isoModule = { config, lib, pkgs, ... }: {
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
        getty = {
          greetingLine = ''<<< Welcome to Openmesh Xnode/OS ${config.system.nixos.label} (\m) - \l >>>'';
        };
        openmesh.xnode.admin = {
          enable = true;
        };
      };
      boot = {
        loader = {
          timeout = lib.mkForce 1;
          grub = {
            timeoutStyle = lib.mkForce "countdown";
          };
        };
      };
      isoImage = {
        forceTextMode = true;
        makeBiosBootable = true;
        makeEfiBootable = true;
        makeUsbBootable = true;
      };
      environment = {
        systemPackages = with pkgs; [
          prometheus
          grafana
#          (callPackage ./xnode-admin {})
#          (callPackage ./openmesh-core {})
        ];
      };
      networking = {
        hostName = "xnode";
      };
      users = {
        users = {
          "xnode" = {
            isNormalUser = true;
            password = "xnode";
          };
        };
      };
    };
  };
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "iso";
  modules = [
    isoModule
  ];
}
