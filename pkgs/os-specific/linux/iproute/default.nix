{fetchurl, stdenv, flex, bison, db4, iptables}:

stdenv.mkDerivation rec {
  name = "iproute2-2.6.35";

  src = fetchurl {
    url = "http://devresources.linux-foundation.org/dev/iproute2/download/${name}.tar.bz2";
    sha256 = "18why1wy0v859axgrlfxn80zmskss0410hh9rf5gn9cr29zg9cla";
  };
 
  preConfigure =
    ''
      patchShebangs ./configure
      sed -e '/ARPDDIR/d' -i Makefile
    '';
  postConfigure = "cat Config";

  makeFlags = "DESTDIR= LIBDIR=$(out)/lib SBINDIR=$(out)/sbin"
   + " CONFDIR=$(out)/etc DOCDIR=$(out)/share/doc/${name}"
  + " MANDIR=$(out)/share/man";

  buildInputs = [bison flex db4 iptables];

  meta = {
    homepage =
      http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2;
    description = "A collection of utilities for controlling TCP / IP"
      + " networking and traffic control in Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
