{ fetchurl, stdenv, flex, bison, db, iptables, pkgconfig }:

stdenv.mkDerivation rec {
  name = "iproute2-3.19.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/iproute2/${name}.tar.xz";
    sha256 = "1c6pgysxfqs5qkd4kpwkbdhw3xydhjnskrz1q2k2nvqndv1ziyg2";
  };

  patch = [ ./vpnc.patch ];

  preConfigure = ''
    patchShebangs ./configure
    sed -e '/ARPDDIR/d' -i Makefile
  '';

  makeFlags = [
    "DESTDIR="
    "LIBDIR=$(out)/lib"
    "SBINDIR=$(out)/sbin"
    "CONFDIR=$(out)/etc"
    "DOCDIR=$(out)/share/doc/${name}"
    "MANDIR=$(out)/share/man"
  ];

  buildInputs = [ db iptables ];
  nativeBuildInputs = [ bison flex pkgconfig ];

  enableParallelBuilding = true;

  # Get rid of useless TeX/SGML docs.
  postInstall = "rm -rf $out/share/doc";

  meta = with stdenv.lib; {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2;
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ eelco wkennington ];
  };
}
