args: with args;

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "hal-0.5.13";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1by8z7vy1c1m3iyh57rlqx6rah5gj6kx3ba30s9305bnffij5kzb";
  };
  
  buildInputs = [
    pkgconfig python pciutils expat libusb dbus.libs dbus_glib glib
    libuuid perl perlXMLParser gettext zlib gperf
    consolekit policykit libsmbios
    # !!! libsmbios is broken; it doesn't install headers.
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

  propagatedBuildInputs = [libusb libsmbios];

  preConfigure = ''
    for i in hald/linux/probing/probe-smbios.c hald/linux/osspec.c \
             hald/linux/coldplug.c hald/linux/blockdev.c \
             tools/hal-storage-mount.c ./tools/hal-storage-shared.c \
             tools/hal-system-power-pm-is-supported.c \
             tools/linux/hal-*-linux
    do
      substituteInPlace $i \
        --replace /usr/sbin/dmidecode ${dmidecode}/sbin/dmidecode \
        --replace /sbin/udevadm ${udev}/sbin/udevadm \
        --replace /bin/mount ${utillinuxng}/bin/mount \
        --replace /bin/umount ${utillinuxng}/bin/umount \
        --replace /usr/bin/pm-is-supported ${pmutils}/bin/pm-is-supported \
        --replace /usr/sbin/pm ${pmutils}/sbin/pm
    done
  '';

  installFlags = "slashsbindir=$(out)/sbin";
}
