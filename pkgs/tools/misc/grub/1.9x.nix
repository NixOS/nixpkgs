{ fetchurl, stdenv, bison, ncurses, libusb, freetype }:

let unifont_bdf = fetchurl {
      url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
      sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
    };
in

stdenv.mkDerivation rec {
  name = "grub-1.97beta3";

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/grub/grub-1.97~beta3.tar.gz";
    sha256 = "1drbv8157xs5v76smls1n14i5c9lahybgwdqvk9w4imcakfnsfca";
    name = "${name}.tar.gz";
  };

  buildInputs = [ bison ncurses libusb freetype ];

  patchPhase =
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

         Briefly, boot loader is the first software program that runs when a
         computer starts.  It is responsible for loading and transferring
         control to the operating system kernel software (such as the Hurd or
         the Linux).  The kernel, in turn, initializes the rest of the
         operating system (e.g., GNU).
      '';

    homepage = http://www.gnu.org/software/grub/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
