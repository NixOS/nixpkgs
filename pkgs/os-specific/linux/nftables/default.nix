{ stdenv, fetchurl, pkgconfig, docbook2x, docbook_xml_dtd_45
, flex, bison, libmnl, libnftnl, gmp, readline }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "nftables-${version}";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${name}.tar.bz2";
    sha256 = "14bygs6vg2v448cw5r4pxqi8an29hw0m9vab8hpmgjmrzjsq30dd";
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
  };
}
