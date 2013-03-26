{ fetchurl, stdenv, flex, bison, db4, iptables, pkgconfig }:

stdenv.mkDerivation rec {
  name = "iproute2-3.8.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/iproute2/${name}.tar.xz";
    sha256 = "0kqy30wz2krbg4y7750hjq5218hgy2vj9pm5qzkn1bqskxs4b4ap";
  };

  patches = [ ./vpnc.patch ];

  preConfigure =
    ''
      patchShebangs ./configure
      sed -e '/ARPDDIR/d' -i Makefile
    '';

  postConfigure = "cat Config";

  makeFlags = "DESTDIR= LIBDIR=$(out)/lib SBINDIR=$(out)/sbin"
    + " CONFDIR=$(out)/etc DOCDIR=$(out)/share/doc/${name}"
    + " MANDIR=$(out)/share/man";

  buildInputs = [ db4 iptables ];
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
