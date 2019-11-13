{ stdenv, fetchurl, pkgconfig, bison, flex
, asciidoc, libxslt, findXMLCatalogs, docbook_xml_dtd_45, docbook_xsl
, libmnl, libnftnl, libpcap
, gmp, jansson, readline
, withXtables ? false , iptables
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.2";
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.bz2";
    sha256 = "1x8kalbggjq44j4916i6vyv1rb20dlh1dcsf9xvzqsry2j063djw";
  };

  configureFlags = [
    "--with-json"
  ] ++ optional withXtables "--with-xtables";

  nativeBuildInputs = [
    pkgconfig bison flex
    asciidoc libxslt findXMLCatalogs docbook_xml_dtd_45 docbook_xsl
  ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp readline jansson
  ] ++ optional withXtables iptables;

  meta = {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
