{ fetchurl, stdenv, xz, flex, bison, gettext, ncurses, libusb, freetype, qemu
, EFIsupport ? false }:

let
    prefix = "grub${if EFIsupport then "-efi" else ""}";
    version = "1.99";
    unifont_bdf = fetchurl {
      url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
      sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
    };
in

stdenv.mkDerivation rec {
  name = "${prefix}-${version}";

  src = fetchurl {
    url = "mirror://gnu/grub/grub-${version}.tar.xz";
    sha256 = "06q2a7bg1mbsms604a89fkdnwrc1jg9hr2mmfdmg3il39j6i827k";
  };

  buildNativeInputs = [ xz flex bison ];
  buildInputs = [ ncurses libusb freetype gettext ]
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

  prePatch =
    '' gunzip < "${unifont_bdf}" > "unifont.bdf"
       sed -i "configure" \
           -e "s|/usr/src/unifont.bdf|$PWD/unifont.bdf|g"
    '';

  configureFlags =
    let arch = if stdenv.system == "i686-linux" then "i386"
               else if stdenv.system == "x86_64-linux" then "x86_64"
               else throw "unsupported EFI firmware architecture";
    in
      stdenv.lib.optionals EFIsupport
        [ "--with-platform=efi" "--target=${arch}" "--program-prefix=" ];

  doCheck = false;
  enableParallelBuilding = true;

  meta = {
    description = "GNU GRUB, the Grand Unified Boot Loader (2.x beta)";

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

    maintainers = with stdenv.lib.maintainers; [ ludo shlevy ];

    platforms = if EFIsupport then
      [ "i686-linux" "x86_64-linux" ]
    else
      stdenv.lib.platforms.gnu;
  };
}
