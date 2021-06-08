{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libcap
, json_c
, readline
, net-snmp
, perl
, texinfo
, pkg-config
, c-ares
, python3
, python3Packages
, libyang
, flex
, bison
, openssl
, czmq
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "frr";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0lzsvi3kl9zcd4k04vc3363z9v2yrp7wc8bziv6w9h5fznh2vkxp";
  };

  buildInputs = [ readline net-snmp c-ares json_c python3 libyang openssl czmq ]
    ++ lib.optionals stdenv.isLinux [ libcap ];

  nativeBuildInputs = [ pkg-config perl texinfo autoreconfHook python3Packages.sphinx python3Packages.pytest flex bison ];

  configureFlags = [
    "--sysconfdir=/etc/frr"
    "--localstatedir=/run/frr"
    "--sbindir=$(out)/libexec/frr"
    "--disable-exampledir"
    "--enable-user=frr"
    "--enable-group=frr"
    "--enable-configfile-mask=0640"
    "--enable-logfile-mask=0640"
    "--enable-vty-group=frrvty"
    "--enable-snmp"
    "--enable-multipath=64"
  ];

  postPatch = ''
    substituteInPlace tools/frr-reload --replace /usr/lib/frr/ $out/libexec/frr/
  '';

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) frr; };

  meta = with lib; {
    description = "FRR BGP/OSPF/ISIS/RIP/RIPNG routing daemon suite";
    longDescription = ''
      FRRouting (FRR) is a free and open source Internet routing protocol suite
      for Linux and Unix platforms. It implements BGP, OSPF, RIP, IS-IS, PIM,
      LDP, BFD, Babel, PBR, OpenFabric and VRRP, with alpha support for EIGRP
      and NHRP.

      FRR’s seamless integration with native Linux/Unix IP networking stacks
      makes it a general purpose routing stack applicable to a wide variety of
      use cases including connecting hosts/VMs/containers to the network,
      advertising network services, LAN switching and routing, Internet access
      routers, and Internet peering.

      FRR has its roots in the Quagga project. In fact, it was started by many
      long-time Quagga developers who combined their efforts to improve on
      Quagga’s well-established foundation in order to create the best routing
      protocol stack available. We invite you to participate in the FRRouting
      community and help shape the future of networking.

      Join the ranks of network architects using FRR for ISPs, SaaS
      infrastructure, web 2.0 businesses, hyperscale services, and Fortune 500
      private clouds.
    '';
    homepage = "https://frrouting.org/";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ woffs ];
  };
}
