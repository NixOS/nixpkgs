{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto
, makeWrapper, pygobject, pygtk, docbook_xml_dtd_412, docbook_xsl
, pythonDBus, libxml2, desktop_file_utils, libusb1, cups, pycups
, pythonPackages
, withGUI ? true
}:

let majorVersion = "1.5";

in stdenv.mkDerivation rec {
  name = "system-config-printer-${majorVersion}.7";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/system-config-printer/${majorVersion}/${name}.tar.xz";
    sha256 = "1cg9n75rg5l9vr1925n2g771kga33imikyl0mf70lww2sfgvs18r";
  };

  propagatedBuildInputs = [ pythonPackages.pycurl ];

  patches = [ ./detect_serverbindir.patch ];

  buildInputs =
    [ intltool pkgconfig glib udev libusb1 cups xmlto
      libxml2 docbook_xml_dtd_412 docbook_xsl desktop_file_utils
      pythonPackages.python pythonPackages.wrapPython
    ];

  pythonPath =
    [ pythonDBus pycups pygobject pythonPackages.pycurl ]
    ++ stdenv.lib.optionals withGUI [ pygtk pythonPackages.notify ];

  configureFlags =
    [ "--with-udev-rules"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ];

  postInstall =
    ''
      export makeWrapperArgs="--set prefix $out"
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
    '';

  meta = {
    homepage = http://cyberelk.net/tim/software/system-config-printer/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
