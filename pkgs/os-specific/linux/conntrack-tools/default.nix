{ fetchurl, stdenv, flex, bison, pkgconfig, libmnl, libnfnetlink
, libnetfilter_conntrack, libnetfilter_queue, libnetfilter_cttimeout
, libnetfilter_cthelper }:

stdenv.mkDerivation rec {
  name = "conntrack-tools-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/conntrack-tools/files/${name}.tar.bz2";
    sha256 = "e5c423dc077f9ca8767eaa6cf40446943905711c6a8fe27f9cc1977d4d6aa11e";
  };

  buildInputs = [ libmnl libnfnetlink libnetfilter_conntrack libnetfilter_queue
    libnetfilter_cttimeout libnetfilter_cthelper ];
  nativeBuildInputs = [ flex bison pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://conntrack-tools.netfilter.org/;
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
