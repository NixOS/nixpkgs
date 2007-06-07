{ stdenv, fetchurl, pkgconfig, python, pciutils, usbutils, expat
, libusb, dbus, dbus_glib, glib, libvolume_id, perl, perlXMLParser
, gettext, zlib /* required by pciutils */, eject, libsmbios
}:

stdenv.mkDerivation {
  name = "hal-0.5.9";
  
  src = fetchurl {
    url = http://people.freedesktop.org/~david/dist/hal-0.5.9.tar.gz;
    sha256 = "178cm30kshwvs0kf5d3l9cn4hyhfv5h6c6q0qnl0jxhynvpgin35";
  };
  
  buildInputs = [
    pkgconfig python pciutils expat libusb dbus dbus_glib glib
    libvolume_id perl perlXMLParser gettext zlib libsmbios
  ];

  # !!! Hm, maybe the pci/usb.ids location should be in /etc, so that
  # we don't have to rebuild HAL when we update the PCI/USB IDs.  
  configureFlags = "
    --with-pci-ids=${pciutils}/share/pci.ids
    --with-usb-ids=${usbutils}/share/usb.ids
    --disable-docbook-docs
    --disable-gtk-doc
    --localstatedir=/var
    --with-eject=${eject}/bin/eject
  ";

  /*
  preInstall = "
    installFlagsArray=(DESTDIR=$out/destdir)
  ";
  
  postInstall = "
    mv $out/destdir/$out/* $out
    rm -rf $out/destdir
  ";
  */
}
