{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto, wrapGAppsHook
, makeWrapper, gtk3, docbook_xml_dtd_412, docbook_xsl
, libxml2, desktop_file_utils, libusb1, cups, gdk_pixbuf, pango, atk, libnotify
, gobjectIntrospection, libgnome_keyring3
, cups-filters
, pythonPackages
, withGUI ? true
}:

stdenv.mkDerivation rec {
  name = "system-config-printer-${version}";
  version = "1.5.9";

  src = fetchurl {
    url = "https://github.com/zdohnal/system-config-printer/releases/download/v${version}/${name}.tar.gz";
    sha256 = "03bwlpsiqpxzcwd78a7rmwiww4jnqd7kl7il4kx78l1r57lasd2r";
  };

  patches = [ ./detect_serverbindir.patch ];

  buildInputs = [
    intltool pkgconfig glib udev libusb1 cups xmlto
    libxml2 docbook_xml_dtd_412 docbook_xsl desktop_file_utils

    libnotify gobjectIntrospection gdk_pixbuf pango atk
    libgnome_keyring3

    (pythonPackages.python.withPackages (ps: with ps; [
      pycups pycurl dbus-python pygobject3 requests pycairo
    ]))
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  configureFlags = [
    "--with-udev-rules"
    "--with-udevdir=$(out)/etc/udev"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  stripDebugList = [ "bin" "lib" "etc/udev" ];

  postInstall = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$program_PATH"
      --prefix PYTHONPATH : "$out/${pythonPackages.python.sitePackages}"
      --set CUPS_DATADIR "${cups-filters}/share/cups"
    )

    # The below line will be unneeded when the next upstream release arrives.
    sed -i -e "s|/usr/local/bin|$out/bin|" \
      "$out/share/dbus-1/services/org.fedoraproject.Config.Printing.service"

    # Manually expand literal "$(out)", which have failed to expand
    sed -e "s|ExecStart=\$(out)|ExecStart=$out|" \
      -i "$out/etc/systemd/system/configure-printer@.service"
  '';

  meta = with stdenv.lib; {
    homepage = http://cyberelk.net/tim/software/system-config-printer/;
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
