{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto
, makeWrapper, gtk3, docbook_xml_dtd_412, docbook_xsl
, libxml2, desktop_file_utils, libusb1, cups, gdk_pixbuf, pango, atk, libnotify
, cups-filters
, pythonPackages
, withGUI ? true
}:

let majorVersion = "1.5";

in stdenv.mkDerivation rec {
  name = "system-config-printer-${majorVersion}.7";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/system-config-printer/${majorVersion}/${name}.tar.xz";
    sha256 = "1vxczk22f58nbikvj47s2x1gzh6q4mbgwnf091p00h3b6nxppdgn";
  };

  propagatedBuildInputs = [ pythonPackages.pycurl ];

  patches = [ ./detect_serverbindir.patch ];

  buildInputs =
    [ intltool pkgconfig glib udev libusb1 cups xmlto
      libxml2 docbook_xml_dtd_412 docbook_xsl desktop_file_utils
      pythonPackages.python pythonPackages.wrapPython
    ];

  pythonPath = with pythonPackages;
    [ pycups pycurl dbus-python pygobject3 requests2 ];

  configureFlags =
    [ "--with-udev-rules"
      "--with-udevdir=$(out)/etc/udev"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ];

  postInstall =
    let
      giTypelibPath = stdenv.lib.makeSearchPath "lib/girepository-1.0" [ gdk_pixbuf.out gtk3.out pango.out atk.out libnotify.out ];
    in
    ''
      export makeWrapperArgs="--set prefix $out \
          --set GI_TYPELIB_PATH ${giTypelibPath} \
          --set CUPS_DATADIR ${cups-filters}/share/cups"
      wrapPythonPrograms
      # The program imports itself, so we need to move shell wrappers to a proper place.
      fixupWrapper() {
        mv "$out/share/system-config-printer/$2.py" \
           "$out/bin/$1"
        sed -i "s/.$2.py-wrapped/$2.py/g" "$out/bin/$1"
        mv "$out/share/system-config-printer/.$2.py-wrapped" \
           "$out/share/system-config-printer/$2.py"
      }
      fixupWrapper scp-dbus-service scp-dbus-service
      fixupWrapper system-config-printer system-config-printer
      fixupWrapper system-config-printer-applet applet
      # This __init__.py is both executed and imported.
      ( cd $out/share/system-config-printer/troubleshoot
        mv .__init__.py-wrapped __init__.py
      )

      # The below line will be unneeded when the next upstream release arrives.
      sed -i -e "s|/usr/bin|$out/bin|" "$out/share/dbus-1/services/org.fedoraproject.Config.Printing.service"

      # Manually expand literal "$(out)", which have failed to expand
      sed -e "s|ExecStart=\$(out)|ExecStart=$out|" \
          -i "$out/etc/systemd/system/configure-printer@.service"
    '';

  meta = {
    homepage = http://cyberelk.net/tim/software/system-config-printer/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
