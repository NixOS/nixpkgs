let

  # The root device.
  rootDevice = "/dev/hda1";

  # The device on which GRUB should be installed (leave empty if you
  # don't want GRUB to be installed).
  grubDevice = "/dev/hda";

in

  # Build boot scripts for the CD that find the CD-ROM automatically.
  with import ./rescue-system.nix {
    autoDetectRootDevice = false;
    inherit rootDevice;
  };

  
rec {


  systemConfiguration = pkgs.stdenv.mkDerivation {
    name = "system-configuration";
    builder = ./system-configuration.sh;
    inherit (pkgs) grub coreutils gnused gnugrep diffutils;
    inherit grubDevice;
    kernel = pkgs.kernel + "/vmlinuz";
    initrd = initialRamdisk + "/initrd";
  };


}
