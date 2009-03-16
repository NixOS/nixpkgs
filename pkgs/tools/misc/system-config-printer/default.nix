{stdenv, fetchurl, perl, perlXMLParser, autoconf, automake, intltool, gettext, desktop_file_utils}:

stdenv.mkDerivation {
  name = "system-config-printer-0.9.93";
  src = fetchurl {
    url = http://cyberelk.net/tim/data/system-config-printer/system-config-printer-0.9.93.tar.bz2;
    md5 = "b97deae648bc1c5825874d250a9c140c";
  };
  patchPhase = ''
    sed -i -e "s/xmlto/echo xmlto/" Makefile.am # Disable building manual pages
    echo > man/system-config-printer.1
    echo > man/system-config-printer-applet.1
    ./bootstrap
  ''; 
  buildInputs = [ perl perlXMLParser autoconf automake intltool gettext desktop_file_utils ];
}
