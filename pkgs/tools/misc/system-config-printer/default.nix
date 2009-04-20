{stdenv, fetchurl, perl, perlXMLParser, desktop_file_utils}:

stdenv.mkDerivation {
  name = "system-config-printer-0.9.93";
  src = fetchurl {
    url = http://cyberelk.net/tim/data/system-config-printer/system-config-printer-0.9.93.tar.bz2;
    md5 = "b97deae648bc1c5825874d250a9c140c";
  };
  preConfigure = ''
    sed -i -e "s/xmlto/echo xmlto/" Makefile.in # Disable building manual pages
    echo > man/system-config-printer.1
    echo > man/system-config-printer-applet.1
  ''; 
  buildInputs = [ perl perlXMLParser desktop_file_utils ];
}
