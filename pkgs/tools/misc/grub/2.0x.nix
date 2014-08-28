{ stdenv, fetchurl, autogen, flex, bison, python, autoconf, automake
, gettext, ncurses, libusb, freetype, qemu, devicemapper
, linuxPackages ? null
, efiSupport ? false
, zfsSupport ? false
}:

with stdenv.lib;
let
  efiSystems = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "x86_64";
  };

  canEfi = any (system: stdenv.system == system) (mapAttrsToList (name: _: name) efiSystems);

  prefix = "grub${if efiSupport then "-efi" else ""}";

  version = "2.02-beta2";

  unifont_bdf = fetchurl {
    url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
    sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
  };
in (

assert efiSupport -> canEfi;
assert zfsSupport -> linuxPackages != null && linuxPackages.zfs != null;

stdenv.mkDerivation rec {
  name = "${prefix}-${version}";

  src = fetchurl {
    name = "grub-2.02-beta2.tar.xz";
    url = "http://alpha.gnu.org/gnu/grub/grub-2.02~beta2.tar.xz";
    sha256 = "13a13fhc0wf473dn73zhga15mjvkg6vqp4h25dxg4n7am2r05izn";
  };

  nativeBuildInputs = [ autogen flex bison python autoconf automake ];
  buildInputs = [ ncurses libusb freetype gettext devicemapper ]
    ++ optional doCheck qemu
    ++ optional zfsSupport linuxPackages.zfs;

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
    '' sh autogen.sh
       gunzip < "${unifont_bdf}" > "unifont.bdf"
       sed -i "configure" \
           -e "s|/usr/src/unifont.bdf|$PWD/unifont.bdf|g"
    '';

  patches = [ ./fix-bash-completion.patch ];

  configureFlags = optional zfsSupport "--enable-libzfs"
    ++ optionals efiSupport [ "--with-platform=efi" "--target=${efiSystems.${stdenv.system}.target}" "--program-prefix=" ];

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    paxmark pms $out/sbin/grub-{probe,bios-setup}
  '';

  meta = with stdenv.lib; {
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

    license = licenses.gpl3Plus;

    platforms = platforms.gnu;
  };
})
