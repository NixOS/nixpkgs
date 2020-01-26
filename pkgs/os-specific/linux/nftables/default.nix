{ stdenv, fetchurl, pkgconfig, bison, file, flex
, asciidoc, libxslt, findXMLCatalogs, docbook_xml_dtd_45, docbook_xsl
, libmnl, libnftnl, libpcap
, gmp, jansson, readline
, withDebugSymbols ? false
, withPython ? false , python3
, withXtables ? false , iptables
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.3";
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.bz2";
    sha256 = "0y6vbqp6x8w165q65h4n9sba1406gaz0d4744gqszbm7w9f92swm";
  };

  nativeBuildInputs = [
    pkgconfig bison file flex
    asciidoc docbook_xml_dtd_45 docbook_xsl findXMLCatalogs libxslt 
  ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp jansson readline
  ] ++ optional withXtables iptables
    ++ optional withPython python3;

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  configureFlags = [
    "--with-json"
  ] ++ optional (!withDebugSymbols) "--disable-debug"
    ++ optional (!withPython) "--disable-python"
    ++ optional withPython "--enable-python"
    ++ optional withXtables "--with-xtables";

  meta = {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
