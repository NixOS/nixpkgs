{ stdenv, fetchurl, zlib, SDL, alsaLib, pkgconfig, pciutils, libuuid, vde2
, libjpeg, libpng, ncurses }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "qemu-kvm-0.14.1";

  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "09yshk2qzlb37hyp8iygyyf2if2d7r21b7rgkl0jyvv4p1m4z755";
  };

  patches = [ ./smb-tmpdir.patch ];

  buildInputs =
    [ zlib SDL alsaLib pkgconfig pciutils libuuid vde2 libjpeg libpng
      ncurses
    ];

  preBuild =
    ''
      # Don't use a hardcoded path to Samba.
      substituteInPlace ./net.h --replace /usr/sbin/smbd smbd
    '';

  postInstall =
    ''
      # extboot.bin isn't installed due to a bug in the Makefile.
      cp pc-bios/optionrom/extboot.bin $out/share/qemu/

      # Libvirt expects us to be called `qemu-kvm'.  Otherwise it will
      # set the domain type to "qemu" rather than "kvm", which can
      # cause architecture selection to misbehave.
      ln -s $(cd $out/bin && echo qemu-system-*) $out/bin/qemu-kvm
    '';

  meta = {
    homepage = http://www.linux-kvm.org/;
    description = "A full virtualization solution for Linux on x86 hardware containing virtualization extensions";
    platforms = stdenv.lib.platforms.linux;
  };
}
