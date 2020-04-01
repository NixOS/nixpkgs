{ stdenv, fetchgit, flex, bison, python, autoconf, automake, gnulib, libtool
, gettext, ncurses, libusb, freetype, qemu, lvm2, unifont, pkgconfig
, fuse # only needed for grub-mount
, zfs ? null
, efiSupport ? false
, zfsSupport ? true
, xenSupport ? false
}:

with stdenv.lib;
let
  pcSystems = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    aarch64-linux.target = "aarch64";
  };

  # For aarch64, we need to use '--target=aarch64-efi' when building,
  # but '--target=arm64-efi' when installing. Insanity!
  efiSystemsInstall = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    aarch64-linux.target = "arm64";
  };

  canEfi = any (system: stdenv.hostPlatform.system == system) (mapAttrsToList (name: _: name) efiSystemsBuild);
  inPCSystems = any (system: stdenv.hostPlatform.system == system) (mapAttrsToList (name: _: name) pcSystems);

  version = "2.04";

in (

assert efiSupport -> canEfi;
assert zfsSupport -> zfs != null;
assert !(efiSupport && xenSupport);

stdenv.mkDerivation rec {
  pname = "grub";
  inherit version;

  src = fetchgit {
    url = "git://git.savannah.gnu.org/grub.git";
    rev = "${pname}-${version}";
    sha256 = "02gly3xw88pj4zzqjniv1fxa1ilknbq1mdk30bj6qy8n44g90i8w";
  };

  patches = [
    ./fix-bash-completion.patch
  ];

  nativeBuildInputs = [ bison flex python pkgconfig autoconf automake ];
  buildInputs = [ ncurses libusb freetype gettext lvm2 fuse libtool ]
    ++ optional doCheck qemu
    ++ optional zfsSupport zfs;

  hardeningDisable = [ "all" ];

  # Work around a bug in the generated flex lexer (upstream flex bug?)
  NIX_CFLAGS_COMPILE = "-Wno-error";

  preConfigure =
    '' for i in "tests/util/"*.in
       do
         sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g'
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

      patchShebangs .

      ./bootstrap --no-git --gnulib-srcdir=${gnulib}

      substituteInPlace ./configure --replace '/usr/share/fonts/unifont' '${unifont}/share/fonts'
    '';

  configureFlags = [ "--enable-grub-mount" ] # dep of os-prober
    ++ optional zfsSupport "--enable-libzfs"
    ++ optionals efiSupport [ "--with-platform=efi" "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}" "--program-prefix=" ]
    ++ optionals xenSupport [ "--with-platform=xen" "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}"];

  # save target that grub is compiled for
  grubTarget = if efiSupport
               then "${efiSystemsInstall.${stdenv.hostPlatform.system}.target}-efi"
               else if inPCSystems
                    then "${pcSystems.${stdenv.hostPlatform.system}.target}-pc"
                    else "";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
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

    homepage = https://www.gnu.org/software/grub/;

    license = licenses.gpl3Plus;

    platforms = platforms.gnu ++ platforms.linux;
  };
})
