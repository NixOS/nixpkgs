{ fetchgit, stdenv, flex, bison, db, iptables, pkgconfig }:

stdenv.mkDerivation rec {
  name = "iproute2-3.17.0";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git";
    rev = "refs/tags/v3.17.0";
    sha256 = "113ayyy7cjxn0bf67fh4is4z0jysgif016kv7ig0jp6r68xp2spa";
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
