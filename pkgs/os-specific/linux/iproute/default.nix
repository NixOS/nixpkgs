{ fetchurl, stdenv, flex, bison, db, iptables, pkgconfig }:

stdenv.mkDerivation rec {
  name = "iproute2-3.16.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/iproute2/${name}.tar.xz";
    sha256 = "0ybv29m88lccpfrh2dgiqash4c3gfvwwpx9kakvnc8c71rn8l2hz";
  };

  patch = [
    ./vpnc.patch
    ./device-checking.patch # Remove after 3.16.0
  ];

  preConfigure =
    ''
      patchShebangs ./configure
      sed -e '/ARPDDIR/d' -i Makefile
    '';

  makeFlags = "DESTDIR= LIBDIR=$(out)/lib SBINDIR=$(out)/sbin"
    + " CONFDIR=$(out)/etc DOCDIR=$(out)/share/doc/${name}"
    + " MANDIR=$(out)/share/man";

  buildInputs = [ db iptables ];
  nativeBuildInputs = [ bison flex pkgconfig ];

  enableParallelBuilding = true;

  # Get rid of useless TeX/SGML docs.
  postInstall = "rm -rf $out/share/doc";

  meta = {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2;
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
