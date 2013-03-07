{ fetchurl, stdenv, flex, bison, db4, iptables, pkgconfig }:

stdenv.mkDerivation rec {
  name = "iproute2-3.6.0";

  src = fetchurl {
    url = http://kernel.org/pub/linux/utils/net/iproute2/iproute2-3.6.0.tar.xz;
    sha256 = "0d05av2s7p552yszgj6glz6d74jlmg392s7n74hicgqfl16m85rd";
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
