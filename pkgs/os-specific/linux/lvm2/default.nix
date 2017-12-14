{ stdenv, fetchurl, pkgconfig, systemd, libudev, utillinux, coreutils, libuuid
, thin-provisioning-tools, enable_dmeventd ? false }:

let
  version = "2.02.176";
in

stdenv.mkDerivation {
  name = "lvm2-${version}";

  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/releases/LVM2.${version}.tgz";
    sha256 = "0wx4rvy4frdmb66znh2xms2j2n06sm361ki6l5ks4y1ciii87kny";
  };

  configureFlags = [
    "--disable-readline"
    "--enable-udev_rules"
    "--enable-udev_sync"
    "--enable-pkgconfig"
    "--enable-applib"
    "--enable-cmdlib"
  ] ++ stdenv.lib.optional enable_dmeventd " --enable-dmeventd"
  ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libudev libuuid thin-provisioning-tools ];

  preConfigure =
    ''
      substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
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
        --replace $out/sbin/blkid ${utillinux}/sbin/blkid

      # Systemd stuff
      mkdir -p $out/etc/systemd/system $out/lib/systemd/system-generators
      cp scripts/blk_availability_systemd_red_hat.service $out/etc/systemd/system
      cp scripts/lvm2_activation_generator_systemd_red_hat $out/lib/systemd/system-generators
    '';

  meta = {
    homepage = http://sourceware.org/lvm2/;
    description = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    inherit version;
    downloadPage = "ftp://sources.redhat.com/pub/lvm2/";
  };
}
