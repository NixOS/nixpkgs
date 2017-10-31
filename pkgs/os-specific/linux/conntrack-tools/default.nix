{ fetchurl, stdenv, flex, bison, pkgconfig, libmnl, libnfnetlink
, libnetfilter_conntrack, libnetfilter_queue, libnetfilter_cttimeout
, libnetfilter_cthelper, systemd }:

stdenv.mkDerivation rec {
  name = "conntrack-tools-${version}";
  version = "1.4.4";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/conntrack-tools/files/${name}.tar.bz2";
    sha256 = "0v5spmlcw5n6va8z34f82vcpynadb0b54pnjazgpadf0qkyg9jmp";
  };

  buildInputs = [
    libmnl libnfnetlink libnetfilter_conntrack libnetfilter_queue
    libnetfilter_cttimeout libnetfilter_cthelper systemd
  ];
  nativeBuildInputs = [ flex bison pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://conntrack-tools.netfilter.org/;
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx fpletz ];
  };
}
