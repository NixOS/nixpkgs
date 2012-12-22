{ stdenv, fetchurl, pkgconfig, udev, utillinux, coreutils }:

let
  v = "2.02.98";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";

  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/old/LVM2.${v}.tgz";
    sha256 = "0r6q6z8ip6q5qgkzng0saljassp4912k6i21ra10vq7pzrc0l0vi";
  };

  patches = [ ./assume-uevent-generated.patch ];

  configureFlags =
    "--disable-readline --enable-udev_rules --enable-udev_sync --enable-pkgconfig --enable-applib";

  buildInputs = [ pkgconfig udev ];

  preConfigure =
    ''
      substituteInPlace scripts/lvmdump.sh \
        --replace /usr/bin/tr ${coreutils}/bin/tr
      substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
        --replace /usr/sbin/lvm $out/sbin/lvm
    '';

  #patches = [ ./purity.patch ];

  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  # Install systemd stuff.
  #installTargets = "install install_systemd_generators install_systemd_units install_tmpfiles_configuration";

  postInstall =
    ''
      substituteInPlace $out/lib/udev/rules.d/13-dm-disk.rules \
        --replace $out/sbin/blkid ${utillinux}/sbin/blkid
    '';

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
