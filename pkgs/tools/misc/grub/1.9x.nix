{ fetchurl, stdenv, bison, gettext, ncurses, libusb, freetype, qemu }:

let unifont_bdf = fetchurl {
      url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
      sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
    };
in

stdenv.mkDerivation rec {
  name = "grub-1.98";

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/grub/${name}.tar.gz";
    sha256 = "05660x82y2rwrzm0d1c4z07fbh02qwmacsmbbav6fa855s4w3wmy";
  };

  buildInputs = [ bison ncurses libusb freetype gettext ]
    ++ stdenv.lib.optional doCheck qemu;

  preConfigure =
    '' for i in "tests/util/"*.in
       do
         sed -i "$i" -e's|/bin/bash|/bin/sh|g'
       done

       # Apparently, the QEMU executable is no longer called
       # `qemu-system-i386', even on i386.
       #
       # In addition, use `-nodefaults' to avoid errors like:
       #
       #  chardev: opening backend "stdio" failed
       #  qemu: could not open serial device 'stdio': Invalid argument
       #
       # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
       sed -i "tests/util/grub-shell.in" \
           -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'
    '';

  patches =
    [ # The udev rules for LVM create symlinks in /dev/mapper rathe
      # than device nodes, causing GRUB to fail to recognize LVM
      # volumes. See
      # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=550704
      # This ugly workaround makes `find_root_device' use stat() on
      # files in /dev/mapper instead of lstat().
      ./device-mapper-symlinks.patch
    ];

  postPatch =
    '' gunzip < "${unifont_bdf}" > "unifont.bdf"
       sed -i "configure" \
           -e "s|/usr/src/unifont.bdf|$PWD/unifont.bdf|g"
    '';

  doCheck = true;

  meta = {
    description = "GNU GRUB, the Grand Unified Boot Loader (2.x alpha)";

    longDescription =
      '' GNU GRUB is a Multiboot boot loader. It was derived from GRUB, GRand
         Unified Bootloader, which was originally designed and implemented by
         Erich Stefan Boleyn.

         Briefly, the boot loader is the first software program that runs when a
         computer starts.  It is responsible for loading and transferring
         control to the operating system kernel software (such as the Hurd or
         the Linux).  The kernel, in turn, initializes the rest of the
         operating system (e.g., GNU).
      '';

    homepage = http://www.gnu.org/software/grub/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
