{ fetchurl, lib, stdenv, flex, bison, pkg-config, libmnl, libnfnetlink
, libnetfilter_conntrack, libnetfilter_queue, libnetfilter_cttimeout
, libnetfilter_cthelper, systemd
, libtirpc
}:

stdenv.mkDerivation rec {
  pname = "conntrack-tools";
  version = "1.4.6";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/conntrack-tools/files/${pname}-${version}.tar.bz2";
    sha256 = "0psx41bclqrh4514yzq03rvs3cq3scfpd1v4kkyxnic2hk65j22r";
  };

  buildInputs = [
    libmnl libnfnetlink libnetfilter_conntrack libnetfilter_queue
    libnetfilter_cttimeout libnetfilter_cthelper systemd libtirpc
  ];
  nativeBuildInputs = [ flex bison pkg-config ];

  meta = with lib; {
    homepage = "http://conntrack-tools.netfilter.org/";
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "conntrack";
    longDescription = ''
       The conntrack-tools are a set of tools targeted at system administrators.
       They are conntrack, the userspace command line interface, and conntrackd, the userspace daemon.
       The tool conntrack provides a full featured interface that is intended to replace the old /proc/net/ip_conntrack interface.
       Using conntrack, you can view and manage the in-kernel connection tracking state table from userspace.
       On the other hand, conntrackd covers the specific aspects of stateful firewalls to enable highly available scenarios, and can be used as statistics collector as well.

       Since 1.2.0, the conntrack-tools includes the nfct command line utility.
       This utility only supports the nfnetlink_cttimeout by now.
       In the long run, we expect that it will replace conntrack by providing a syntax similar to nftables.
    '';
  };
}
