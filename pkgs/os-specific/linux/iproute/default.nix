{fetchurl, stdenv, flex, bison, db4, iptables}:

stdenv.mkDerivation rec {
  name = "iproute2-2.6.35";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/iproute/iproute2-2.6.35.tar.bz2/b0f281b3124bf04669e18f5fe16d4934/iproute2-2.6.35.tar.bz2";
    sha256 = "18why1wy0v859axgrlfxn80zmskss0410hh9rf5gn9cr29zg9cla";
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

  buildInputs = [db4 iptables];
  buildNativeInputs = [bison flex db4];

  meta = {
    homepage =
      http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2;
    description = "A collection of utilities for controlling TCP / IP"
      + " networking and traffic control in Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
