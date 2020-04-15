{ fetchurl, stdenv, flex, bash, bison, db, iptables, pkgconfig, libelf, libmnl }:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "5.6.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    sha256 = "14j6n1bc09xhq8lxs40vfsx8bb8lx12a07ga4rsxl8vfrqjhwnqv";
  };

  preConfigure = ''
    patchShebangs ./configure
    sed -e '/ARPDDIR/d' -i Makefile
    # Don't build netem tools--they're not installed and require HOSTCC
    substituteInPlace Makefile --replace " netem " " "
  '';

  outputs = [ "out" "dev" ];

  makeFlags = [
    "DESTDIR="
    "LIBDIR=$(out)/lib"
    "SBINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man"
    "BASH_COMPDIR=$(out)/share/bash-completion/completions"
    "DOCDIR=$(TMPDIR)/share/doc/${pname}" # Don't install docs
    "HDRDIR=$(dev)/include/iproute2"
  ];

  buildFlags = [
    "CONFDIR=/etc/iproute2"
  ];

  installFlags = [
    "CONFDIR=$(out)/etc/iproute2"
  ];

  buildInputs = [ db iptables libelf libmnl ];
  nativeBuildInputs = [ bison flex pkgconfig ];

  enableParallelBuilding = true;

  postInstall = ''
    PATH=${bash}/bin:$PATH patchShebangs $out/sbin
  '';

  meta = with stdenv.lib; {
    homepage = "https://wiki.linuxfoundation.org/networking/iproute2";
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ primeos eelco fpletz globin ];
  };
}
