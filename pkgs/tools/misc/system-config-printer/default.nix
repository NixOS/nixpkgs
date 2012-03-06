{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto
, makeWrapper, pygobject, pygtk, docbook_xml_dtd_412, docbook_xsl
, pythonDBus, libxml2, desktop_file_utils, libusb, cups, pycups
, pythonPackages
, withGUI ? true
}:

stdenv.mkDerivation rec {
  name = "${meta.name}-${meta.version}";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/${meta.name}/1.3/${name}.tar.xz";
    sha256 = "1d50rqgpyrzyrxwq3qhafzq9075qm2wxdrh1f1q7whlr0chxi3mw";
  };

  buildInputs =
    [ intltool pkgconfig glib udev libusb cups xmlto
      libxml2 docbook_xml_dtd_412 docbook_xsl desktop_file_utils
      pythonPackages.python pythonPackages.wrapPython
    ];

  pythonPath =
    [ pythonDBus pycups pygobject ]
    ++ stdenv.lib.optionals withGUI [ pygtk pythonPackages.notify ];
    
  configureFlags = "--with-udev-rules";

  postInstall =
    ''
      wrapPythonPrograms
      ( cd $out/share/system-config-printer/troubleshoot
        mv .__init__.py-wrapped __init__.py
      )
    '';

  meta = {
    name = "system-config-printer";
    version = "1.3.4";
  };
}
