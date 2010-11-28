{stdenv, fetchurl, udev, intltool, python, pkgconfig, glib, xmlto,
  makeWrapper, pygobject, pygtk, docbook_xml_dtd_412, docbook_xsl,
  pythonDBus, libxml2, desktop_file_utils, libusb, cups, pycups,
  notify }:

stdenv.mkDerivation rec {
  name = "${meta.name}-${meta.version}";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/${meta.name}/1.2/${name}.tar.bz2";
    sha256 = "16xjvahmdkkix7281gx7ac9zqaxgfb7pjjlgcc6kmw52cifk86ww";
  };
  buildInputs = [ udev intltool python pkgconfig glib xmlto docbook_xml_dtd_412
    libxml2 docbook_xsl desktop_file_utils libusb cups makeWrapper pygobject
    pygtk pythonDBus pycups notify ];

  configureFlags = "--with-udev-rules";

  postInstall = ''
    wrapProgram $out/bin/system-config-printer --set PYTHONPATH "$PYTHONPATH:$(toPythonPath $out):$(toPythonPath ${notify})/gtk-2.0"
  '';

  meta = {
    name = "system-config-printer";
    version = "1.2.4";
  };
}
