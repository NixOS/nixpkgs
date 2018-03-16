{ stdenv, fetchurl, fetchFromSavannah, autogen, flex, bison, python, autoconf, automake
, gettext, ncurses, libusb, freetype, qemu, devicemapper, unifont, pkgconfig
, zfs ? null
, efiSupport ? false
, zfsSupport ? true
, xenSupport ? false
}:

with stdenv.lib;
let
  pcSystems = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "i386";
  };

  efiSystemsBuild = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "x86_64";
    "aarch64-linux".target = "aarch64";
  };

  # For aarch64, we need to use '--target=aarch64-efi' when building,
  # but '--target=arm64-efi' when installing. Insanity!
  efiSystemsInstall = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "x86_64";
    "aarch64-linux".target = "arm64";
  };

  canEfi = any (system: stdenv.system == system) (mapAttrsToList (name: _: name) efiSystemsBuild);
  inPCSystems = any (system: stdenv.system == system) (mapAttrsToList (name: _: name) pcSystems);

  version = "2.02";

in (

assert efiSupport -> canEfi;
assert zfsSupport -> zfs != null;
assert !(efiSupport && xenSupport);

stdenv.mkDerivation rec {
  name = "grub-${version}";

  src = fetchurl {
    url = "mirror://gnu/grub/${name}.tar.xz";
    sha256 = "03vvdfhdmf16121v7xs8is2krwnv15wpkhkf16a4yf8nsfc3f2w1";
  };

  nativeBuildInputs = [ bison flex python pkgconfig ];
  buildInputs = [ ncurses libusb freetype gettext devicemapper ]
    ++ optional doCheck qemu
    ++ optional zfsSupport zfs;

  hardeningDisable = [ "all" ];

  # Work around a bug in the generated flex lexer (upstream flex bug?)
  NIX_CFLAGS_COMPILE = "-Wno-error";

  postPatch = ''
    substituteInPlace ./configure --replace '/usr/share/fonts/unifont' '${unifont}/share/fonts'
  '';

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

      unset CPP # setting CPP intereferes with dependency calculation
    '';

  patches = [ ./fix-bash-completion.patch ];

  configureFlags = optional zfsSupport "--enable-libzfs"
    ++ optionals efiSupport [ "--with-platform=efi" "--target=${efiSystemsBuild.${stdenv.system}.target}" "--program-prefix=" ]
    ++ optionals xenSupport [ "--with-platform=xen" "--target=${efiSystemsBuild.${stdenv.system}.target}"];

  # save target that grub is compiled for
  grubTarget = if efiSupport
               then "${efiSystemsInstall.${stdenv.system}.target}-efi"
               else if inPCSystems
                    then "${pcSystems.${stdenv.system}.target}-pc"
                    else "";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    paxmark pms $out/sbin/grub-{probe,bios-setup}

    # Avoid a runtime reference to gcc
    sed -i $out/lib/grub/*/modinfo.sh -e "/grub_target_cppflags=/ s|'.*'|' '|"
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
