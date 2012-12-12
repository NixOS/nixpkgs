{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto
, makeWrapper, pygobject, pygtk, docbook_xml_dtd_412, docbook_xsl
, pythonDBus, libxml2, desktop_file_utils, libusb1, cups, pycups
, pythonPackages
, withGUI ? true
}:

stdenv.mkDerivation rec {
  name = "system-config-printer-1.3.12";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/system-config-printer/1.3/${name}.tar.xz";
    sha256 = "1cg9n75rg5l9vr1925n2g771kga33imikyl0mf70lww2sfgvs18r";
  };

  buildInputs =
    [ intltool pkgconfig glib udev libusb1 cups xmlto
      libxml2 docbook_xml_dtd_412 docbook_xsl desktop_file_utils
      pythonPackages.python pythonPackages.wrapPython
    ];

  pythonPath =
    [ pythonDBus pycups pygobject ]
    ++ stdenv.lib.optionals withGUI [ pygtk pythonPackages.notify ];

  configureFlags =
    [ "--with-udev-rules"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/systemd"
    ];

  postInstall =
    ''
      wrapPythonPrograms
      ( cd $out/share/system-config-printer/troubleshoot
        mv .__init__.py-wrapped __init__.py
      )
    '';

  meta = {
    homepage = http://cyberelk.net/tim/software/system-config-printer/;
  };
}
