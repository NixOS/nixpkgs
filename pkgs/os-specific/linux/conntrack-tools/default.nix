{ fetchurl, stdenv, flex, bison, pkgconfig, libmnl, libnfnetlink
, libnetfilter_conntrack, libnetfilter_queue, libnetfilter_cttimeout
, libnetfilter_cthelper, systemd }:

stdenv.mkDerivation rec {
  pname = "conntrack-tools";
  version = "1.4.6";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/conntrack-tools/files/${pname}-${version}.tar.bz2";
    sha256 = "0psx41bclqrh4514yzq03rvs3cq3scfpd1v4kkyxnic2hk65j22r";
  };

  buildInputs = [
    libmnl libnfnetlink libnetfilter_conntrack libnetfilter_queue
    libnetfilter_cttimeout libnetfilter_cthelper systemd
  ];
  nativeBuildInputs = [ flex bison pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "http://conntrack-tools.netfilter.org/";
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
