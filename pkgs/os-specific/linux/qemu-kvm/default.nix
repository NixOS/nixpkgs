{ stdenv, fetchurl, zlib, SDL, alsaLib, pkgconfig, pciutils, libuuid, vde2
, libjpeg, libpng, ncurses, python, glib }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "qemu-kvm-0.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "0y247bc2cyawliaiyk8k41kl3mcjvh52b9bgzvxv0h55zwdpg3l2";
  };

  patches = [ ./smb-tmpdir.patch ];

  configureFlags = "--audio-drv-list=alsa";

  enableParallelBuilding = true;

  buildInputs =
    [ zlib SDL alsaLib pkgconfig pciutils libuuid vde2 libjpeg libpng
      ncurses python glib
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
