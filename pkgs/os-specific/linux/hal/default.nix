args: with args;

stdenv.mkDerivation {
  name = "hal-0.5.10";
  
  src = fetchurl {
    url = http://hal.freedesktop.org/releases/hal-0.5.10.tar.gz;
    sha256 = "0k6bgavkry7sl1wwpwfpk15r52b75gfql2qgyijaqaxg826a2was";
  };
  
  buildInputs = [
    pkgconfig python pciutils expat libusb dbus.libs dbus_glib glib
    libvolume_id perl perlXMLParser gettext zlib libsmbios
  ];

  # !!! Hm, maybe the pci/usb.ids location should be in /etc, so that
  # we don't have to rebuild HAL when we update the PCI/USB IDs.  
  configureFlags = "
    --with-pci-ids=${pciutils}/share
    --with-usb-ids=${usbutils}/share
    --disable-docbook-docs
    --disable-gtk-doc
    --localstatedir=/var
    --with-eject=${eject}/bin/eject
  ";

  propagatedBuildInputs = [libusb];

  preBuild = "
    substituteInPlace hald/linux/coldplug.c --replace /usr/bin/udevinfo ${udev}/bin/udevinfo
  ";
}
