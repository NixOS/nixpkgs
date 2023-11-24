{ lib, stdenv, fetchurl
, buildPackages, bison, flex, pkg-config
, db, iptables, libelf, libmnl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "6.5.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-pwF5CF+huW08M7BAyAm3XitXVjrcUFpK0F4mCd83NGM=";
  };

  postPatch = ''
    # Don't try to create /var/lib/arpd:
    sed -e '/ARPDDIR/d' -i Makefile

    substituteInPlace Makefile \
      --replace "CC := gcc" "CC ?= $CC"
  '';

  outputs = [ "out" "dev" ];

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
  buildInputs = [ db iptables libelf libmnl ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://wiki.linuxfoundation.org/networking/iproute2";
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ primeos eelco fpletz globin ];
  };
}
