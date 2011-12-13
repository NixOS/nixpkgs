{ stdenv, fetchurl, pkgconfig, python, pciutils, expat
, libusb, dbus, dbus_glib, glib, libuuid, perl
, perlXMLParser, gettext, zlib, gperf, consolekit, policykit
, libsmbios, dmidecode, udev, utillinux, pmutils, usbutils
, eject, upstart
}:

assert stdenv ? glibc;

let
  isPC = stdenv.isi686 || stdenv.isx86_64;
  changeDmidecode = if isPC then
    "--replace /usr/sbin/dmidecode ${dmidecode}/sbin/dmidecode"
    else "";
in
stdenv.mkDerivation rec {
  name = "hal-0.5.14";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "00ld3afcbh4ckb8sli63mm2w69zh6ip4axhy1lxyybgiabxaqfij";
  };

  buildInputs = [
    pkgconfig python pciutils expat libusb dbus.libs dbus_glib glib
    libuuid perl perlXMLParser gettext zlib gperf
    consolekit policykit
  ];

  # !!! Hm, maybe the pci/usb.ids location should be in /etc, so that
  # we don't have to rebuild HAL when we update the PCI/USB IDs.
  configureFlags = ''
    --with-pci-ids=${pciutils}/share
    --with-usb-ids=${usbutils}/share
    --localstatedir=/var
    --with-eject=${eject}/bin/eject
    --with-linux-input-header=${stdenv.glibc}/include/linux/input.h
    --enable-umount-helper
  '';

  propagatedBuildInputs = [ libusb ]
    ++ stdenv.lib.optional isPC libsmbios;

  preConfigure = ''
    for i in hald/linux/probing/probe-smbios.c hald/linux/osspec.c \
             hald/linux/coldplug.c hald/linux/blockdev.c \
             tools/hal-storage-mount.c ./tools/hal-storage-shared.c \
             tools/hal-system-power-pm-is-supported.c \
             tools/linux/hal-*-linux
    do
      substituteInPlace $i \
        ${changeDmidecode} \
        ${if udev != null then "--replace /sbin/udevadm ${udev}/sbin/udevadm" else ""} \
        --replace /bin/mount ${utillinux}/bin/mount \
        --replace /bin/umount ${utillinux}/bin/umount \
        --replace /usr/bin/pm-is-supported ${pmutils}/bin/pm-is-supported \
        --replace /usr/sbin/pm ${pmutils}/sbin/pm \
        --replace /sbin/shutdown ${upstart}/sbin/shutdown
    done
  '';

  installFlags = "slashsbindir=$(out)/sbin";
}
