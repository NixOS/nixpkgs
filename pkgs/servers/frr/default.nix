{ lib
, stdenv
, fetchFromGitHub

# build time
, autoreconfHook
, flex
, bison
, perl
, pkg-config
, texinfo

# runtime
, c-ares
, json_c
, libcap
, libelf
, libunwind
, libyang
, net-snmp
, openssl
, pam
, pcre2
, python3
, readline
, rtrlib

# tests
, nettools
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "frr";
  version = "8.5.2";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-xJCaVh/PlV6WRv/JRHO/vzF72E6Ap8/RaqLnkYTnk14=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
    python3.pkgs.sphinx
    texinfo
  ];

  buildInputs = [
    c-ares
    json_c
    libelf
    libunwind
    libyang
    net-snmp
    openssl
    pam
    pcre2
    python3
    readline
    rtrlib
  ] ++ lib.optionals stdenv.isLinux [
    libcap
  ];

  configureFlags = [
    "--disable-exampledir"
    "--enable-configfile-mask=0640"
    "--enable-group=frr"
    "--enable-logfile-mask=0640"
    "--enable-multipath=64"
    "--enable-snmp"
    "--enable-user=frr"
    "--enable-vty-group=frrvty"
    "--localstatedir=/run/frr"
    "--sbindir=$(out)/libexec/frr"
    "--sysconfdir=/etc/frr"
    "--enable-rpki"
  ];

  postPatch = ''
    substituteInPlace tools/frr-reload \
      --replace /usr/lib/frr/ $out/libexec/frr/
  '';

  doCheck = true;

  nativeCheckInputs = [
    nettools
    python3.pkgs.pytest
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://frrouting.org/";
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
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ woffs ];
    platforms = platforms.unix;
  };

  passthru.tests = { inherit (nixosTests) frr; };
}
