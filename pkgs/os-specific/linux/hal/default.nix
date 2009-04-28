args: with args;

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "hal-0.5.11";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "145s20fzb4gaqxmv3r6i29ndwgnap95ric63n1z6g2gp80iry2kk";
  };
  
  buildInputs = [
    pkgconfig python pciutils expat libusb dbus.libs dbus_glib glib
    libvolume_id perl perlXMLParser gettext zlib libsmbios gperf
    # !!! libsmbios is broken; it doesn't install headers.
  ];

  # !!! Hm, maybe the pci/usb.ids location should be in /etc, so that
  # we don't have to rebuild HAL when we update the PCI/USB IDs.  
  configureFlags = ''
    --with-pci-ids=${pciutils}/share
    --with-usb-ids=${usbutils}/share
    --disable-docbook-docs
    --disable-gtk-doc
    --localstatedir=/var
    --with-eject=${eject}/bin/eject
    --disable-policy-kit
  '';

  propagatedBuildInputs = [libusb];

  preConfigure = ''
    substituteInPlace hald/linux/coldplug.c --replace /usr/bin/udevinfo ${udev}/bin/udevinfo

    substituteInPlace tools/Makefile.in --replace /usr/include ${stdenv.glibc}/include
  '';
}
