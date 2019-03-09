{ fetchurl, stdenv, flex, bash, bison, db, iptables, pkgconfig, libelf }:

stdenv.mkDerivation rec {
  name = "iproute2-${version}";
  version = "4.20.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/iproute2/${name}.tar.xz";
    sha256 = "1a7xyvqjxfnm7rk21amm0xgxa38clg7q7cmc4dmlg27q81mambf8";
  };

  preConfigure = ''
    patchShebangs ./configure
    sed -e '/ARPDDIR/d' -i Makefile
    # Don't build netem tools--they're not installed and require HOSTCC
    substituteInPlace Makefile --replace " netem " " "
  '';

  outputs = [ "out" "dev"];

  makeFlags = [
    "DESTDIR="
    "LIBDIR=$(out)/lib"
    "SBINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man"
    "BASH_COMPDIR=$(out)/share/bash-completion/completions"
    "DOCDIR=$(TMPDIR)/share/doc/${name}" # Don't install docs
    "HDRDIR=$(dev)/include/iproute2"
  ];

  buildFlags = [
    "CONFDIR=/etc/iproute2"
  ];

  installFlags = [
    "CONFDIR=$(out)/etc/iproute2"
  ];

  buildInputs = [ db iptables libelf ];
  nativeBuildInputs = [ bison flex pkgconfig ];

  enableParallelBuilding = true;

  postInstall = ''
    PATH=${bash}/bin:$PATH patchShebangs $out/sbin
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.linuxfoundation.org/networking/iproute2;
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ eelco fpletz ];
  };
}
