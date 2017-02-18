{ stdenv, fetchurl, libcap, libnl, readline, net_snmp, less, perl, texinfo,
  pkgconfig, c-ares }:

stdenv.mkDerivation rec {
  name = "quagga-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://savannah/quagga/${name}.tar.gz";
    sha256 = "1qyw675hrs3f67zprdbyw91wldmyihv97ibn1f99ypcp6x6n8hqh";
  };

  buildInputs =
    [ readline net_snmp c-ares ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libcap libnl ];

  nativeBuildInputs = [ pkgconfig perl texinfo ];

  configureFlags = [
    "--sysconfdir=/etc/quagga"
    "--localstatedir=/run/quagga"
    "--sbindir=$(out)/libexec/quagga"
    "--disable-exampledir"
    "--enable-user=quagga"
    "--enable-group=quagga"
    "--enable-configfile-mask=0640"
    "--enable-logfile-mask=0640"
    "--enable-vtysh"
    "--enable-vty-group=quaggavty"
    "--enable-snmp"
    "--enable-multipath=64"
    "--enable-rtadv"
    "--enable-irdp"
    "--enable-opaque-lsa"
    "--enable-ospf-te"
    "--enable-pimd"
    "--enable-isis-topology"
  ];

  preConfigure = ''
    substituteInPlace vtysh/vtysh.c --replace \"more\" \"${less}/bin/less\"
  '';

  postInstall = ''
    rm -f $out/bin/test_igmpv3_join
    mv -f $out/libexec/quagga/ospfclient $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Quagga BGP/OSPF/ISIS/RIP/RIPNG routing daemon suite";
    longDescription = ''
      GNU Quagga is free software which manages TCP/IP based routing protocols.
      It supports BGP4, BGP4+, OSPFv2, OSPFv3, IS-IS, RIPv1, RIPv2, and RIPng as
      well as the IPv6 versions of these.

      As the predecessor Zebra has been considered orphaned, the Quagga project
      has been formed by members of the zebra mailing list and the former
      zebra-pj project to continue developing.

      Quagga uses threading if the kernel supports it, but can also run on
      kernels that do not support threading. Each protocol has its own daemon.

      It is more than a routed replacement, it can be used as a Route Server and
      a Route Reflector.
    '';
    homepage = http://www.nongnu.org/quagga/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tavyc ];
  };
}
