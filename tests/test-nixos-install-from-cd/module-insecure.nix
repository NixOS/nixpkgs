# this allows logging in as root without password.

# This module is shared by the iso configuration and the system configuration
# which is build by the test

{pkgs, config, ...}:

let
  doOverride = pkgs.lib.mkOverride 0 {};
in

{

  services.sshd = {
    enable = true;
    permitRootLogin = "yes";
  };
  jobs.sshd = {
    startOn = doOverride "started network-interfaces";
  };

  boot.initrd.kernelModules =
    ["cifs" "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "nls_utf8"];

  environment.systemPackages = [ pkgs.vim_configurable ];

  # FIXME: rewrite pam.services the to be an attr list
  # I only want to override sshd
  security.pam.services = doOverride
      # Most of these should be moved to specific modules.
      [ { name = "cups"; }
        { name = "ejabberd"; }
        { name = "ftp"; }
        { name = "lshd"; rootOK =true; allowNullPassword =true; }
        { name = "passwd"; }
        { name = "samba"; }
        { name = "sshd"; rootOK = true; allowNullPassword =true; }
        { name = "xlock"; }
        { name = "chsh"; rootOK = true; }
        { name = "su"; rootOK = true; forwardXAuth = true; }
        # Note: useradd, groupadd etc. aren't setuid root, so it
        # doesn't really matter what the PAM config says as long as it
        # lets root in.
        { name = "useradd"; rootOK = true; }
        # Used by groupadd etc.
        { name = "shadow"; rootOK = true; }
        { name = "login"; ownDevices = true; allowNullPassword = true; }
      ];

}
