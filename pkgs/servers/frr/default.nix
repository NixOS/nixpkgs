{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, python3Packages

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

# tests
, nettools
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "frr";
  version = "8.1";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-hJcgLiPBxOE5QEh0RhtZhM3dOxFqW5H0TUjN+aP4qRk=";
  };

  patches = [
    (fetchpatch {
      # Fix clippy build on aarch64-linux
      # https://github.com/FRRouting/frr/issues/10267
      url = "https://github.com/FRRouting/frr/commit/3942ee1f7bc754dd0dd9ae79f89d0f2635be334f.patch";
      sha256 = "1i0acfy5k9fbm9cxchrcvkhyw9704srq4wm2hyjqgdimm2dq7ryf";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
    python3Packages.sphinx
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
  ] ++ lib.optionals stdenv.isLinux [
    libcap
  ];

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

  doCheck = true;
  checkInputs = [
    nettools
    python3Packages.pytest
  ];

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
