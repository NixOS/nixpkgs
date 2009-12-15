# configuration used to build ISO used to install NixOS when running NixOS kvm installation test

# The configuration is prebuild before starting the vm because starting the vm
# causes some overhead.
{pkgs, config, ...}:

let
  doOverride = pkgs.lib.mkOverride 0 {};
in

{

  # make system boot and accessible:
  require = [ ./module-insecure.nix
              ../../modules/installer/cd-dvd/installation-cd-minimal.nix
            ];

  fonts = {
    enableFontConfig = false; 
  };

  boot.loader.grub.timeout = doOverride 0; 
  boot.loader.grub.default = 2;
  boot.loader.grub.version = doOverride 2;

}
