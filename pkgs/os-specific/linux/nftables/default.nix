{ stdenv, fetchurl, pkgconfig, docbook2x, docbook_xml_dtd_45
, flex, bison, libmnl, libnftnl, gmp, readline }:

stdenv.mkDerivation rec {
  name = "nftables-0.4";

  src = fetchurl {
    url = "http://netfilter.org/projects/nftables/files/${name}.tar.bz2";
    sha256 = "0g0x6mf5580kr1azrff0ryxxym43qr72fwir7agmz4b8bjvnkjpn";
  };

  configureFlags = [
    "CONFIG_MAN=y"
    "DB2MAN=docbook2man"
  ];

  XML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  buildInputs = [ pkgconfig docbook2x flex bison libmnl libnftnl gmp readline ];

  meta = with stdenv.lib; {
    description = "the project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = http://netfilter.org/projects/nftables;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
