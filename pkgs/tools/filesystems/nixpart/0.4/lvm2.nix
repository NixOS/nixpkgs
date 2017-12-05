{ stdenv, fetchurl, pkgconfig, systemd, utillinux, coreutils }:

let
  v = "2.02.106";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";

  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/releases/LVM2.${v}.tgz";
    sha256 = "0nr833bl0q4zq52drjxmmpf7bs6kqxwa5kahwwxm9411khkxz0vc";
  };

  configureFlags =
    "--disable-readline --enable-udev_rules --enable-udev_sync --enable-pkgconfig --enable-applib";

  buildInputs = [ pkgconfig systemd ];

  preConfigure =
    ''
      substituteInPlace scripts/lvmdump.sh \
        --replace /usr/bin/tr ${coreutils}/bin/tr
      substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
        --replace /usr/sbin/lvm $out/sbin/lvm \
        --replace /usr/bin/udevadm ${systemd}/bin/udevadm

      sed -i /DEFAULT_SYS_DIR/d Makefile.in
      sed -i /DEFAULT_PROFILE_DIR/d conf/Makefile.in
    '';

  enableParallelBuilding = true;

  #patches = [ ./purity.patch ];

  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  # Install systemd stuff.
  #installTargets = "install install_systemd_generators install_systemd_units install_tmpfiles_configuration";

  postInstall =
    ''
      substituteInPlace $out/lib/udev/rules.d/13-dm-disk.rules \
        --replace $out/sbin/blkid ${utillinux.bin}/sbin/blkid

      # Systemd stuff
      mkdir -p $out/etc/systemd/system $out/lib/systemd/system-generators
      cp scripts/blk_availability_systemd_red_hat.service $out/etc/systemd/system
      cp scripts/lvm2_activation_generator_systemd_red_hat $out/lib/systemd/system-generators
    '';

  meta = {
    homepage = http://sourceware.org/lvm2/;
    description = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
