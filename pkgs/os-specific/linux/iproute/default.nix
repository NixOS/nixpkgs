{ lib, stdenv, fetchurl, fetchpatch
, buildPackages, bison, flex, pkg-config
, db, iptables, libelf, libmnl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "5.18.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    sha256 = "W6PUZNUcjCg1UNUH/6w9EPeuxYe3xmsMy2lQZDZGOJ4=";
  };

  patches = [
    # To avoid ./configure failing due to invalid arguments:
    (fetchpatch { # configure: restore backward compatibility
      url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/patch/?id=a3272b93725a406bc98b67373da67a4bdf6fcdb0";
      sha256 = "0hyagh2lf6rrfss4z7ca8q3ydya6gg7vfhh25slhpgcn6lnk0xbv";
    })
  ];

  preConfigure = ''
    # Don't try to create /var/lib/arpd:
    sed -e '/ARPDDIR/d' -i Makefile
  '';

  outputs = [ "out" "dev" ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/sbin"
    "DOCDIR=$(TMPDIR)/share/doc/${pname}" # Don't install docs
    "HDRDIR=$(dev)/include/iproute2"
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
    inherit pname version;
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
