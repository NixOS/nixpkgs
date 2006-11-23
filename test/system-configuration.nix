let

  # The root device.
  rootDevice = "/dev/hda1";

  # The device on which GRUB should be installed (leave empty if you
  # don't want GRUB to be installed).
  grubDevice = "/dev/hda";

  # Build boot scripts.
  bootEnv = import ./boot-environment.nix {
    autoDetectRootDevice = false;
    inherit rootDevice;
    stage2Init = "/init"; # !!! should be bootEnv.bootStage2;
    readOnlyRoot = false;
  };

in

with bootEnv;
  
rec {


  systemConfiguration = pkgs.stdenv.mkDerivation {
    name = "system-configuration";
    builder = ./system-configuration.sh;
    inherit (pkgs) grub coreutils gnused gnugrep diffutils;
    inherit grubDevice;
    inherit bootStage2;
    inherit grubMenuBuilder;
    kernel = pkgs.kernel + "/vmlinuz";
    initrd = initialRamdisk + "/initrd";
  };


  grubMenuBuilder = pkgs.genericSubstituter {
    src = ./grub-menu-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
  };


}
