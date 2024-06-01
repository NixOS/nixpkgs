{ config, lib, pkgs, ... }: {

  config = {
    isoImage = {
        forceTextMode = true;
        makeBiosBootable = true;
        makeEfiBootable = true;
        makeUsbBootable = true;
      };
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
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
      };
      #xnode-admin = {
      #  enable = true;
      #};
    };
    boot = {
      loader = {
        timeout = lib.mkForce 1;
        grub = {
          timeoutStyle = lib.mkForce "countdown";
        };
      };
    };
    environment = {
      systemPackages = with pkgs; [
        prometheus grafana xnode-admin openmesh-core
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
}