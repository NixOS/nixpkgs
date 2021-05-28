{ stdenv, fetchurl
, buildPackages, bison, flex, pkg-config
, db, iptables, libelf, libmnl
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "5.8.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0vk4vickrpahdhl3zazr2qn2bf99v5549ncirjpwiy4h0a4izkfg";
  };

  preConfigure = ''
    # Don't try to create /var/lib/arpd:
    sed -e '/ARPDDIR/d' -i Makefile
    # TODO: Drop temporary version fix for 5.8 (53159d81) once 5.9 is out:
    substituteInPlace include/version.h \
      --replace "v5.7.0-77-gb687d1067169" "5.8.0"
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

  meta = with stdenv.lib; {
    homepage = "https://wiki.linuxfoundation.org/networking/iproute2";
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ primeos eelco fpletz globin ];
  };
}
