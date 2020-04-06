{ stdenv, fetchurl
, bison, flex, pkg-config
, db, iptables, libelf, libmnl
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "5.5.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0ywg70f98wgfai35jl47xzpjp45a6n7crja4vc8ql85cbi1l7ids";
  };

  preConfigure = ''
    # Don't try to create /var/lib/arpd:
    sed -e '/ARPDDIR/d' -i Makefile
    # Don't build netem tools--they're not installed and require HOSTCC
    substituteInPlace Makefile --replace " netem " " "
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
