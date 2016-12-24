{ stdenv, fetchurl, pkgconfig, systemd, libudev, utillinux, coreutils, libuuid
, enable_dmeventd ? false
}:

stdenv.mkDerivation rec {
  name = "lvm2-${version}";
  version = "2.02.168";

  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/releases/LVM2.${version}.tgz";
    sha256 = "03b62hcsj9z37ckd8c21wwpm07s9zblq7grfh58yzcs1vp6x38r3";
  };

  configureFlags = [
    "--disable-readline"
    "--enable-udev_rules"
    "--enable-udev_sync"
    "--enable-pkgconfig"
    "--enable-applib"
    "--enable-cmdlib"
  ] ++ stdenv.lib.optional enable_dmeventd " --enable-dmeventd";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libudev libuuid ];

  preConfigure = ''
    substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
      --replace /usr/bin/udevadm ${systemd.udev.bin}/bin/udevadm
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "systemd_dir=$(out)/lib/systemd"
    "systemd_unit_dir=$(systemd_dir)/system"
    "systemd_generator_dir=$(systemd_dir)/system-generators"
  ];

  installFlags = [ "confdir=$(out)/etc/lvm" "DEFAULT_SYS_DIR=$(confdir)" ];
  installTargets = [
    "install" "install_systemd_generators" "install_systemd_units"
  ];

  postInstall = ''
    substituteInPlace $out/lib/udev/rules.d/13-dm-disk.rules \
      --replace $out/sbin/blkid ${utillinux}/sbin/blkid
  '';

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    downloadPage = "ftp://sources.redhat.com/pub/lvm2/";
  };
}
