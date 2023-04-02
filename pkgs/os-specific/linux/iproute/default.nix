{ lib, stdenv, fetchurl, fetchpatch
, buildPackages, bison, flex, pkg-config
, db, iptables, libelf, libmnl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "6.2.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-TXJzAgDsWyqrqhovIFU8Z0gpLwZdmhVMfV4iVZ35/WI=";
  };

  patches = [
    # To avoid ./configure failing due to invalid arguments:
    (fetchpatch { # configure: restore backward compatibility
      url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/patch/?id=a3272b93725a406bc98b67373da67a4bdf6fcdb0";
      sha256 = "0hyagh2lf6rrfss4z7ca8q3ydya6gg7vfhh25slhpgcn6lnk0xbv";
    })

    # fix build on musl. applied anywhere to prevent patchrot.
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/iproute2/min.patch?id=4b78dbe29d18151402052c56af43cc12d04b1a69";
      sha256 = "sha256-0ROZQAN3mUPPgggictr23jyA4JDG7m9vmBUhgRp4ExY=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "SHARED_LIBS=n"
    # all build .so plugins:
    "TC_CONFIG_NO_XT=y"
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
