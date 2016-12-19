{ fetchurl, stdenv, flex, bison, pkgconfig, libmnl, libnfnetlink
, libnetfilter_conntrack, libnetfilter_queue, libnetfilter_cttimeout
, libnetfilter_cthelper }:

stdenv.mkDerivation rec {
  name = "conntrack-tools-${version}";
  version = "1.4.3";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/conntrack-tools/files/${name}.tar.bz2";
    sha256 = "0mrzrzp6y41pmxc6ixc4fkgz6layrpwsmzb522adzzkc6mhcqg5g";
  };

  buildInputs = [ libmnl libnfnetlink libnetfilter_conntrack libnetfilter_queue
    libnetfilter_cttimeout libnetfilter_cthelper ];
  nativeBuildInputs = [ flex bison pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://conntrack-tools.netfilter.org/;
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}
