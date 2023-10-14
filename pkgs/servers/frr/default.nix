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
, buildPackages

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
, protobufc

# tests
, nettools
, nixosTests

# FRR's configure.ac gets SNMP options by executing net-snmp-config on the build host
# This leads to compilation errors when cross compiling.
# E.g. net-snmp-config for x86_64 does not return the ARM64 paths.
#
#   SNMP_LIBS="`${NETSNMP_CONFIG} --agent-libs`"
#   SNMP_CFLAGS="`${NETSNMP_CONFIG} --base-cflags`"
, snmpSupport ? stdenv.buildPlatform.canExecute stdenv.hostPlatform

# other general options besides snmp support
, rpkiSupport ? true
, numMultipath ? 64
, watchfrrSupport ? true
, cumulusSupport ? false
, datacenterSupport ? true
, rtadvSupport ? true
, irdpSupport ? true
, routeReplacementSupport ? true
, mgmtdSupport ? true

# routing daemon options
, bgpdSupport ? true
, ripdSupport ? true
, ripngdSupport ? true
, ospfdSupport ? true
, ospf6dSupport ? true
, ldpdSupport ? true
, nhrpdSupport ? true
, eigrpdSupport ? true
, babeldSupport ? true
, isisdSupport ? true
, pimdSupport ? true
, pim6dSupport ? true
, sharpdSupport ? true
, fabricdSupport ? true
, vrrpdSupport ? true
, pathdSupport ? true
, bfddSupport ? true
, pbrdSupport ? true
, staticdSupport ? true

# BGP options
, bgpAnnounce ? true
, bgpBmp ? true
, bgpVnc ? true

# OSPF options
, ospfApi ? true
}:

lib.warnIf (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  "cannot enable SNMP support due to cross-compilation issues with net-snmp-config"

stdenv.mkDerivation rec {
  pname = "frr";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-o0AVx7sDRowQz6NpKPQThC8NcGA3QN8xFzfE0k4AIVg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
    python3.pkgs.sphinx
    texinfo
    protobufc
  ];

  buildInputs = [
    c-ares
    json_c
    libelf
    libunwind
    libyang
    openssl
    pam
    pcre2
    python3
    readline
    rtrlib
    protobufc
  ] ++ lib.optionals stdenv.isLinux [
    libcap
  ] ++ lib.optionals snmpSupport [
    net-snmp
  ];

  # otherwise in cross-compilation: "configure: error: no working python version found"
  depsBuildBuild = [
    buildPackages.python3
  ];

  # cross-compiling: clippy is compiled with the build host toolchain, split it out to ease
  # navigation in dependency hell
  clippy-helper = buildPackages.callPackage ./clippy-helper.nix { frrVersion = version; frrSource = src; };

  configureFlags = [
    "--disable-silent-rules"
    "--disable-exampledir"
    "--enable-configfile-mask=0640"
    "--enable-group=frr"
    "--enable-logfile-mask=0640"
    "--enable-multipath=${toString numMultipath}"
    "--enable-user=frr"
    "--enable-vty-group=frrvty"
    "--localstatedir=/run/frr"
    "--sbindir=$(out)/libexec/frr"
    "--sysconfdir=/etc/frr"
    "--with-clippy=${clippy-helper}/bin/clippy"
    # general options
    (lib.strings.enableFeature snmpSupport "snmp")
    (lib.strings.enableFeature rpkiSupport "rpki")
    (lib.strings.enableFeature watchfrrSupport "watchfrr")
    (lib.strings.enableFeature rtadvSupport "rtadv")
    (lib.strings.enableFeature irdpSupport "irdp")
    (lib.strings.enableFeature routeReplacementSupport "rr-semantics")
    (lib.strings.enableFeature mgmtdSupport "mgmtd")

    # routing protocols
    (lib.strings.enableFeature bgpdSupport "bgpd")
    (lib.strings.enableFeature ripdSupport "ripd")
    (lib.strings.enableFeature ripngdSupport "ripngd")
    (lib.strings.enableFeature ospfdSupport "ospfd")
    (lib.strings.enableFeature ospf6dSupport "ospf6d")
    (lib.strings.enableFeature ldpdSupport "ldpd")
    (lib.strings.enableFeature nhrpdSupport "nhrpd")
    (lib.strings.enableFeature eigrpdSupport "eigrpd")
    (lib.strings.enableFeature babeldSupport "babeld")
    (lib.strings.enableFeature isisdSupport "isisd")
    (lib.strings.enableFeature pimdSupport "pimd")
    (lib.strings.enableFeature pim6dSupport "pim6d")
    (lib.strings.enableFeature sharpdSupport "sharpd")
    (lib.strings.enableFeature fabricdSupport "fabricd")
    (lib.strings.enableFeature vrrpdSupport "vrrpd")
    (lib.strings.enableFeature pathdSupport "pathd")
    (lib.strings.enableFeature bfddSupport "bfdd")
    (lib.strings.enableFeature pbrdSupport "pbrd")
    (lib.strings.enableFeature staticdSupport "staticd")
    # BGP options
    (lib.strings.enableFeature bgpAnnounce "bgp-announce")
    (lib.strings.enableFeature bgpBmp "bgp-bmp")
    (lib.strings.enableFeature bgpVnc "bgp-vnc")
    # OSPF options
    (lib.strings.enableFeature ospfApi "ospfapi")
    # Cumulus options
    (lib.strings.enableFeature cumulusSupport "cumulus")
    # Datacenter options
    (lib.strings.enableFeature datacenterSupport "datacenter")
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
    maintainers = with maintainers; [ woffs thillux ];
    # adapt to platforms stated in http://docs.frrouting.org/en/latest/overview.html#supported-platforms
    platforms = (platforms.linux ++ platforms.freebsd ++ platforms.netbsd ++ platforms.openbsd);
  };

  passthru.tests = { inherit (nixosTests) frr; };
}
