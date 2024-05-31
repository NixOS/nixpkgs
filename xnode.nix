{ config, lib, pkgs ? import ./packages, ... }: {

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
        prometheus grafana #openmesh-core
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
          #openssh.authorizedKeys.keys = [ sshPubKey ]; # Inject a key from environment or through --args
        };
      };
    };
  };
}