{ stdenv, fetchurl, pkgconfig, docbook2x, docbook_xml_dtd_45
, flex, bison, libmnl, libnftnl, gmp, readline }:

stdenv.mkDerivation rec {
  version = "0.8.3";
  name = "nftables-${version}";

  src = fetchurl {
    url = "http://netfilter.org/projects/nftables/files/${name}.tar.bz2";
    sha256 = "0f2yv7as1ybkfvn75f72x0z9y1ydibw4s3hbzhlmvsc8vgsy2syi";
  };

  configureFlags = [
    "CONFIG_MAN=y"
    "DB2MAN=docbook2man"
  ];

  XML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  nativeBuildInputs = [ pkgconfig docbook2x flex bison ];
  buildInputs = [ libmnl libnftnl gmp readline ];

  meta = with stdenv.lib; {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = http://netfilter.org/projects/nftables;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
