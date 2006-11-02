# Create an initial ramdisk containing the specified set of packages.
# An initial ramdisk is used during the initial stages of booting a
# Linux system.  It is loaded by the boot loader along with the kernel
# image.  It's supposed to contain everything (such as kernel modules)
# necessary to allow us to mount the root file system.  Once the root
# file system is mounted, the `real' boot script can be called.
#
# An initrd is really just a gzipped cpio archive.
#
# A symlink `/init' is made to the store path passed in the `init'
# argument.

{stdenv, cpio, packages, init}:

stdenv.mkDerivation {
  name = "initrd";
  builder = ./make-initrd.sh;
  buildInputs = [cpio];
  inherit packages init;
}
