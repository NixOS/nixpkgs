{ lib, stdenv, fetchurl, fetchpatch
, buildPackages, bison, flex, pkg-config
, db, iptables, elfutils, libmnl ,libbpf
, gitUpdater, pkgsStatic
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "6.11.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-H3lTmKBK6qzQao9qziz9kTwz+llTypnaroO7XFNGEcM=";
  };

  patches = [
    (fetchurl {
      name = "musl-endian.patch";
      url = "https://lore.kernel.org/netdev/20240712191209.31324-1-contact@hacktivis.me/raw";
      hash = "sha256-MX+P+PSEh6XlhoWgzZEBlOV9aXhJNd20Gi0fJCcSZ5E=";
    })
    (fetchurl {
      name = "musl-msghdr.patch";
      url = "https://lore.kernel.org/netdev/20240712191209.31324-2-contact@hacktivis.me/raw";
      hash = "sha256-X5BYSZBxcvdjtX1069a1GfcpdoVd0loSAe4xTpbCipA=";
    })
    (fetchurl {
      name = "musl-basename.patch";
      url = "https://lore.kernel.org/netdev/20240804161054.942439-1-dilfridge@gentoo.org/raw";
      hash = "sha256-47obv6mIn/HO47lt47slpTAFDxiQ3U/voHKzIiIGCTM=";
    })
    (fetchpatch {
      name = "musl-mst.patch";
      url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/patch/?id=6a77abab92516e65f07f8657fc4e384c4541ce0e";
      hash = "sha256-19FzTDvgnmqVFBykVgXl4VIsHs8Cy9NWGOLpxifxVlI=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "CC := gcc" "CC ?= $CC"
  '';

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--color" "auto"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/sbin"
    "DOCDIR=$(TMPDIR)/share/doc/${pname}" # Don't install docs
    "HDRDIR=$(dev)/include/iproute2"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "SHARED_LIBS=n"
    # all build .so plugins:
    "TC_CONFIG_NO_XT=y"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "HOSTCC=$(CC_FOR_BUILD)"
  ];

  buildFlags = [
    "CONFDIR=/etc/iproute2"
  ];

  installFlags = [
    "CONFDIR=$(out)/etc/iproute2"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ]; # netem requires $HOSTCC
  nativeBuildInputs = [ bison flex pkg-config ];
  buildInputs = [ db iptables libmnl  ]
    # needed to uploaded bpf programs
    ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
      elfutils libbpf
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git";
    rev-prefix = "v";
  };
  # needed for nixos-anywhere
  passthru.tests.static = pkgsStatic.iproute2;

  meta = with lib; {
    homepage = "https://wiki.linuxfoundation.org/networking/iproute2";
    description = "Collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ primeos fpletz globin ];
  };
}
