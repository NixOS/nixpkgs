{ lib, stdenv, fetchurl, fetchpatch
, buildPackages, bison, flex, pkg-config
, db, iptables, libelf, libmnl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "6.4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-TFG43svH5NoVn/sGb1kM+5Pb+a9/+GsWR85Ct8F5onI=";
  };

  patches = [
    # To avoid ./configure failing due to invalid arguments:
    (fetchpatch { # configure: restore backward compatibility
      url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/patch/?id=a3272b93725a406bc98b67373da67a4bdf6fcdb0";
      sha256 = "0hyagh2lf6rrfss4z7ca8q3ydya6gg7vfhh25slhpgcn6lnk0xbv";
    })

    # fix build on musl. applied anywhere to prevent patchrot.
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/iproute2/include.patch?id=bd46efb8a8da54948639cebcfa5b37bd608f1069";
      sha256 = "sha256-NpNnSXQntuzzpjswE42yzo7nqmrQgI5YcHR2kp9NEwA=";
    })
  ];

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
