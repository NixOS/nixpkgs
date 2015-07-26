{ fetchurl, stdenv, flex, bison, db, iptables, pkgconfig }:

stdenv.mkDerivation rec {
  name = "iproute2-4.1.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/iproute2/${name}.tar.xz";
    sha256 = "0vz6m2k6hdrjlg4x0r3cd75lg9ysmndbsp35pm8494zvksc7l1vk";
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
